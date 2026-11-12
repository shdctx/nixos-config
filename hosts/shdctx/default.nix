# Control panel for the desktop PC: switch components on or off here.
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  my = {
    user.name = "shdctx";

    hardware = {
      cpu.amd.enable = true;
      gpu.amd.enable = true;
      bluetooth.enable = true;
    };

    desktop.hyprland.enable = true;

    # App groups. Add the apps themselves in modules/nixos/features/<group>.nix
    browser.enable = true;
    communication.enable = true;
    cybersecurity.enable = true;
    development.enable = true;
    gaming.enable = true;
    media.enable = true;
    office.enable = true;
    printing3d.enable = true;
    virtualization.enable = false;
    remote-desktop.enable = true;
    vpn.enable = true;

    # Pull this repository on every boot and build it for the next boot
    autoUpdate.enable = true;
  };

  # Check the btrfs file system for errors once a month
  services.btrfs.autoScrub.enable = true;

  # The NixOS release this PC was first installed with. Leave it unchanged,
  # even after updates: https://nixos.org/manual/nixos/unstable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
