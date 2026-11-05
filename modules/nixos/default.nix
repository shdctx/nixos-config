# Imports every .nix file below this directory automatically, so a new module
# only needs a new file. Modules that are optional guard themselves with an
# `enable` option, which is switched on or off in hosts/<host>/default.nix.
{ lib, ... }:
{
  imports = lib.filter (path: lib.hasSuffix ".nix" (toString path) && path != ./default.nix) (
    lib.filesystem.listFilesRecursive ./.
  );
}
