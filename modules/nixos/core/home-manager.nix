{ config, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Rename existing files that would be overwritten instead of failing
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };

    users.${config.my.user.name}.imports = [
      ../../home
      ../../../users/${config.my.user.name}.nix
    ];
  };
}
