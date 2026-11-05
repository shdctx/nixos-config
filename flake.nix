{
  description = "NixOS configuration for shdctx's desktop PC";

  inputs = {
    # Rolling release: the newest packages, kernels and drivers
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk layout (see hosts/shdctx/disko.nix)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            ./modules/nixos
            ./hosts/${hostName}
            {
              networking.hostName = hostName;
              # `nixos-version --configuration-revision` shows the commit the system was built from
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };

      # Runs `Hyprland --verify-config` on each host's generated config, so a
      # mistake in hyprland.lua fails CI instead of breaking the desktop
      hyprlandChecks = lib.concatMapAttrs (
        name: host:
        let
          inherit (host) config;
          homeFiles = config.home-manager.users.${config.my.user.name}.home-files;
        in
        lib.optionalAttrs config.my.desktop.hyprland.enable {
          "hyprland-config-${name}" = pkgs.runCommandLocal "check-hyprland-config-${name}" { } ''
            export HOME=$TMPDIR XDG_RUNTIME_DIR=$TMPDIR XDG_CONFIG_HOME=$TMPDIR/config
            mkdir -p $XDG_CONFIG_HOME
            cp -rL ${homeFiles}/.config/hypr $XDG_CONFIG_HOME/
            ${lib.getExe' config.programs.hyprland.package "Hyprland"} --verify-config \
              --config $XDG_CONFIG_HOME/hypr/hyprland.lua
            touch $out
          '';
        }
      ) self.nixosConfigurations;
    in
    {
      nixosConfigurations = {
        shdctx = mkHost "shdctx";
      };

      # `nix fmt` formats every Nix file in the repository
      formatter.${system} = pkgs.nixfmt-tree;

      # `nix flake check` runs these, and so does CI
      checks.${system} = {
        formatting = pkgs.runCommandLocal "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          find ${self} -name '*.nix' -exec nixfmt --check {} +
          touch $out
        '';

        # Finds unused code (let bindings, function arguments)
        deadnix = pkgs.runCommandLocal "check-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          deadnix --fail --no-lambda-pattern-names ${self}
          touch $out
        '';
      }
      // hyprlandChecks;
    };
}
