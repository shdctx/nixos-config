{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    # Delete old generations regularly, because the auto-update creates a new
    # one whenever the repository changed
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow apps that aren't open source (Steam, Discord, ...)
  nixpkgs.config.allowUnfree = true;

  # Needed to clone and update this repository
  programs.git.enable = true;
}
