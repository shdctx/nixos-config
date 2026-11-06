# Chat, voice and e-mail apps.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.communication.enable = lib.mkEnableOption "communication apps";

  config = lib.mkIf config.my.communication.enable {
    environment.systemPackages = with pkgs; [
      (discord.override { withVencord = true; })
      teamspeak6-client # teamspeak
      thunderbird # e-mail
    ];
  };
}
