# Web browsers.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.browser.enable = lib.mkEnableOption "web browsers";

  config = lib.mkIf config.my.browser.enable {
    environment.systemPackages = with pkgs; [
      # Add apps here, e.g. chromium
    ];

    # Some apps are set up with an option instead of a package
    programs.firefox.enable = true;
  };
}
