{
  networking.networkmanager.enable = true;

  # DNS through systemd-resolved, so Tailscale and WireGuard DNS work
  services.resolved.enable = true;
}
