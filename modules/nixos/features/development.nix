# Programming tools and editors.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.development.enable = lib.mkEnableOption "development tools";

  config = lib.mkIf config.my.development.enable {
    environment.systemPackages = with pkgs; [
      # Add apps here, e.g. vscode
    ];
  };
}
