# Virtual machines and containers.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.virtualization.enable = lib.mkEnableOption "virtual machines and containers";

  config = lib.mkIf config.my.virtualization.enable {
    environment.systemPackages = with pkgs; [
      # Add apps here
    ];

    # Most of this is set up with options instead of packages, e.g.:
    # programs.virt-manager.enable = true;
    # virtualisation.libvirtd.enable = true;
    # virtualisation.docker.enable = true;
  };
}
