# Office suite, documents and notes.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.office.enable = lib.mkEnableOption "office apps";

  config = lib.mkIf config.my.office.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      # Spell checking in LibreOffice
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
    ];
  };
}
