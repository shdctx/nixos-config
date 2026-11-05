# Control panel for the desktop PC: switch components on or off here.
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  my = {
    user.name = "shdctx";
  };

  # Check the btrfs file system for errors once a month
  services.btrfs.autoScrub.enable = true;

  # The NixOS release this PC was first installed with. Leave it unchanged,
  # even after updates: https://nixos.org/manual/nixos/unstable/options#opt-system.stateVersion
  system.stateVersion = "26.11";
}
