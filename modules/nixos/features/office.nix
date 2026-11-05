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
      # Add apps here, e.g. libreoffice
    ];
  };
}
