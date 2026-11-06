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
      brave
    ];

    # Browser policies for Brave (and other Chromium-based browsers).
    # Extensions listed here are installed automatically. Other groups add
    # their own extensions the same way, e.g. media.nix and cybersecurity.nix.
    # Find an extension's ID at the end of its Chrome Web Store URL.
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
