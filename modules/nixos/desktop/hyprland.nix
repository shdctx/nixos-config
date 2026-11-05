# System side of the Hyprland desktop. The per-user side (keybindings, bar,
# terminal, ...) is in modules/home/desktop/.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.desktop.hyprland.enable = lib.mkEnableOption "the Hyprland desktop";

  config = lib.mkIf config.my.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      # nixpkgs' prebuilt Hyprland is built with UWSM support. Matching it lets
      # Hyprland be downloaded from the binary cache instead of compiled
      # locally. It only adds a "Hyprland (UWSM)" entry to the login menu.
      withUWSM = true;
    };

    # Text login screen. Starts Hyprland by default; F3 picks another session.
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--remember"
        "--remember-session"
        "--asterisks"
        "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        "--cmd ${lib.getExe' config.programs.hyprland.package "start-hyprland"}"
      ];
    };

    # File picker dialogs for apps that use portals (browsers, Electron, Flatpak)
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # Run Electron and Chromium apps natively on Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    security.polkit.enable = true;
    programs.dconf.enable = true; # settings storage for GTK apps

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        font-awesome # icons in Waybar
      ];
    };
  };
}
