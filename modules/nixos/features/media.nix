# Players and editors for music, video and images.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.media.enable = lib.mkEnableOption "media apps";

  config = lib.mkIf config.my.media.enable {
    environment.systemPackages = with pkgs; [
      vlc # video player
      spotify
    ];

    # Some apps are set up with an option instead of a package, e.g.:
    # programs.obs-studio.enable = true;
  };
}
