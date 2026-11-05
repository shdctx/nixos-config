# Keeps the PC up to date with this repository:
#
#   1. Two minutes after every boot, `nixos-config-pull` fast-forwards the local
#      clone to the latest commit on GitHub (running git as the clone's owner).
#   2. `nixos-config-update` then builds that commit with `nixos-rebuild boot`,
#      so the new system is used from the next boot on.
#
# It does nothing if there are uncommitted changes in the clone or if another
# branch is checked out, so it never touches work in progress.
# Logs: journalctl -b -u nixos-config-pull -u nixos-config-update
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.autoUpdate;

  pull = pkgs.writeShellApplication {
    name = "nixos-config-pull";
    runtimeInputs = [
      pkgs.git
      pkgs.openssh
    ];
    text = ''
      cd ${lib.escapeShellArg cfg.directory}

      if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
        echo "Uncommitted changes in $PWD, skipping the update." >&2
        exit 1
      fi

      branch="$(git symbolic-ref --short HEAD)"
      if [ "$branch" != ${lib.escapeShellArg cfg.branch} ]; then
        echo "Branch '$branch' is checked out instead of '${cfg.branch}', skipping the update." >&2
        exit 1
      fi

      # The network can need a moment after boot, so try a few times
      for attempt in 1 2 3 4 5; do
        if git fetch --quiet origin "$branch"; then
          break
        fi
        if [ "$attempt" -eq 5 ]; then
          echo "Could not fetch from origin, skipping the update." >&2
          exit 1
        fi
        sleep 30
      done

      # Fails (and skips the update) if local commits have diverged from GitHub
      git merge --ff-only "origin/$branch"
    '';
  };
in
{
  options.my.autoUpdate = {
    enable = lib.mkEnableOption "pulling this repository on every boot and building it for the next boot";

    directory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.my.user.name}/nixos-config";
      defaultText = lib.literalExpression ''"/home/''${config.my.user.name}/nixos-config"'';
      description = "Local git clone of this repository.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = config.my.user.name;
      defaultText = lib.literalExpression "config.my.user.name";
      description = "Owner of the clone. git runs as this user.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Branch to follow.";
    };
  };

  config = lib.mkIf cfg.enable {
    # The system is built by root from a clone owned by the user. Git and Nix
    # refuse to open another user's repository unless it's marked as safe.
    programs.git = {
      enable = true;
      config.safe.directory = [ cfg.directory ];
    };

    systemd.services.nixos-config-pull = {
      description = "Pull the latest nixos-config";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.ConditionPathExists = "${cfg.directory}/.git";
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart = lib.getExe pull;
      };
    };

    systemd.services.nixos-config-update = {
      description = "Build the latest nixos-config for the next boot";
      requires = [ "nixos-config-pull.service" ];
      after = [ "nixos-config-pull.service" ];
      unitConfig.ConditionPathExists = "${cfg.directory}/.git";
      path = [
        config.nix.package
        pkgs.git
      ];
      environment.HOME = "/root";
      serviceConfig = {
        Type = "oneshot";
        # Build in the background without slowing down the desktop
        Nice = 19;
        IOSchedulingClass = "idle";
      };
      script = ''
        ${config.system.build.nixos-rebuild}/bin/nixos-rebuild boot \
          --flake ${lib.escapeShellArg "${cfg.directory}#${config.networking.hostName}"} \
          --no-update-lock-file
      '';
    };

    systemd.timers.nixos-config-update = {
      description = "Update nixos-config after every boot";
      wantedBy = [ "timers.target" ];
      timerConfig.OnBootSec = "2min";
    };
  };
}
