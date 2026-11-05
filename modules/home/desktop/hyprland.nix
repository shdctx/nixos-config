# Per-user side of the Hyprland desktop: config, bar, terminal, launcher and
# notifications. The system side is in modules/nixos/desktop/hyprland.nix.
{ lib, osConfig, ... }:
{
  config = lib.mkIf osConfig.my.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # Hyprland itself is installed by the NixOS module
      package = null;
      portalPackage = null;

      configType = "lua";
      # Your settings, keybindings and autostart: edit ./hyprland.lua
      # (it ends up in ~/.config/hypr/settings.lua)
      extraLuaFiles.settings = ./hyprland.lua;

      # Give services started with the session (Waybar, portals, ...) the full
      # session environment
      systemd.variables = [ "--all" ];
    };

    # Status bar
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.main = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "tray"
        ];
      };
    };

    programs.kitty.enable = true; # terminal (SUPER + Q)
    programs.fuzzel.enable = true; # app launcher (SUPER + R)
    services.mako.enable = true; # notifications
    services.hyprpolkitagent.enable = true; # password prompts for admin actions
  };
}
