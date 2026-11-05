{ pkgs, ... }:
{
  boot = {
    # Newest stable kernel. The RX 9070 XT (RDNA 4) needs at least 6.12, and
    # newer kernels bring the latest amdgpu and Zen 5 improvements.
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        # Keeps the EFI partition from filling up with old generations
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Compressed swap in RAM
  zramSwap.enable = true;
}
