# VPNs and private networks.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.vpn.enable = lib.mkEnableOption "VPN tools";

  config = lib.mkIf config.my.vpn.enable {
    environment.systemPackages = with pkgs; [
      wireguard-tools # wg and wg-quick
    ];

    # Log in once with: sudo tailscale up
    services.tailscale.enable = true;

    # Trust traffic coming in over Tailscale
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
