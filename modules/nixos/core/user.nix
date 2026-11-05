{ config, lib, ... }:
{
  options.my.user.name = lib.mkOption {
    type = lib.types.str;
    description = "Name of the main user account.";
  };

  config.users.users.${config.my.user.name} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
    ];
  };
}
