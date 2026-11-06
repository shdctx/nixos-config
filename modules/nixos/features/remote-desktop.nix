# Remote desktop.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.remote-desktop.enable = lib.mkEnableOption "remote desktop tools";

  config = lib.mkIf config.my.remote-desktop.enable {
    environment.systemPackages = with pkgs; [
      rustdesk
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # needed to capture the screen under Hyprland
      openFirewall = true;
    };
  };
}
