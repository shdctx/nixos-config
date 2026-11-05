{ config, lib, ... }:
{
  options.my.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf config.my.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Tray applet and settings window, since Hyprland has none built in
    services.blueman.enable = true;
  };
}
