{
  description = "NixOS configuration for shdctx's desktop PC";

  inputs = {
    # Rolling release: the newest packages, kernels and drivers
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk layout (see hosts/shdctx/disko.nix)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            ./modules/nixos
            ./hosts/${hostName}
            {
              networking.hostName = hostName;
              # `nixos-version --configuration-revision` shows the commit the system was built from
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        shdctx = mkHost "shdctx";
      };

      # `nix fmt` formats every Nix file in the repository
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
