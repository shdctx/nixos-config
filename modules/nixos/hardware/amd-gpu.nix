{ config, lib, ... }:
{
  options.my.hardware.gpu.amd.enable = lib.mkEnableOption "AMD Radeon GPU support";

  config = lib.mkIf config.my.hardware.gpu.amd.enable {
    # Mesa: RADV for Vulkan and radeonsi for OpenGL. Both use the open-source
    # amdgpu kernel driver, so nothing else is needed.
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # needed by Steam and most Windows games under Proton
    };

    # Load amdgpu early, for a full-resolution boot screen
    hardware.amdgpu.initrd.enable = true;

    # GPU firmware
    hardware.enableRedistributableFirmware = true;

    # For fan curves, power limits and overclocking, try LACT:
    # services.lact.enable = true;
  };
}
