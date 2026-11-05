# Games, launchers and gaming tools.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.gaming.enable = lib.mkEnableOption "gaming apps";

  config = lib.mkIf config.my.gaming.enable {
    environment.systemPackages = with pkgs; [
      mangohud # FPS and performance overlay
    ];

    # Some apps are set up with an option instead of a package
    programs.steam.enable = true;
  };
}
