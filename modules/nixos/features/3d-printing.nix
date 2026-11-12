# 3D printing: slicers and printer tools.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.printing3d.enable = lib.mkEnableOption "3D printing apps";

  config = lib.mkIf config.my.printing3d.enable {
    environment.systemPackages = with pkgs; [
      anycubic-slicer-next # custom package, see pkgs/anycubic-slicer-next
    ];
  };
}
