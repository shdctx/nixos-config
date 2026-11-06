# Cyber security: recon, threat intelligence and proxy tools.
# Find package and option names at https://search.nixos.org
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.cybersecurity.enable = lib.mkEnableOption "cyber security tools";

  config = lib.mkIf config.my.cybersecurity.enable {
    environment.systemPackages = with pkgs; [
      # Add apps here, e.g. nmap
    ];

    # Browser extensions (installed in Brave, see browser.nix)
    programs.chromium.extensions = [
      "gcknhkkoolaabfmlnjonogaaifnjlfnp" # FoxyProxy
      "jjalcfnidlmpjhdfepjhjbhnhkbgleap" # Shodan
      "glhjgodpcooejchnadnlhifaeokhfncc" # VirusTotal URL Scanner
      "efbjojhplkelaegfbieplglfidafgoka" # VT4Browsers + Google TI
      "gppongmhjkpfnbhagpmjfkannfbllamg" # Wappalyzer
    ];
  };
}
