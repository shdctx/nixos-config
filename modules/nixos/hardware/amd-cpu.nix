{ config, lib, ... }:
{
  options.my.hardware.cpu.amd.enable = lib.mkEnableOption "AMD Ryzen CPU support";

  config = lib.mkIf config.my.hardware.cpu.amd.enable {
    hardware.cpu.amd.updateMicrocode = true;

    # Let the CPU manage its own clock speeds (best for Zen 2 and newer)
    boot.kernelParams = [ "amd_pstate=active" ];

    # Hardware virtualization (KVM)
    boot.kernelModules = [ "kvm-amd" ];
  };
}
