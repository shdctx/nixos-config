# Cyber security.
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
      # Scanning and traffic
      nmap
      tcpdump
      netcat-openbsd
      socat

      # Passwords
      hashcat
      john

      # Exploitation
      metasploit

      # Web testing (point FoxyProxy at Burp to intercept Brave's traffic)
      burpsuite
      ffuf
      sqlmap

      # Recon and OSINT
      subfinder
      exiftool
    ];

    # Wireshark
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark; # the GUI version
    };
    users.users.${config.my.user.name}.extraGroups = [ "wireshark" ];

    # OpenCL on the Radeon GPU (ROCm), so hashcat can use the GPU
    hardware.amdgpu.opencl.enable = true;

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
