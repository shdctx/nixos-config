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
      chromium
    ];

    programs.chromium = {
      enable = true;
      extensions = [
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
        "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
        "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
      ];
    };
  };
}
