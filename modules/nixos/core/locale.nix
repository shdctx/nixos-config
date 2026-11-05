{
  time.timeZone = "Europe/Berlin";

  # English system language with German formats (dates, numbers, units, paper size)
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # German keyboard on the console and login screen. Hyprland has its own
  # setting in modules/home/desktop/hyprland.lua.
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";
}
