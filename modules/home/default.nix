# Home Manager modules. Like modules/nixos, every .nix file below this
# directory is imported automatically. They follow the NixOS switches through
# `osConfig`, so turning a component off in hosts/<host>/default.nix also
# removes its per-user settings.
{ lib, ... }:
{
  imports = lib.filter (path: lib.hasSuffix ".nix" (toString path) && path != ./default.nix) (
    lib.filesystem.listFilesRecursive ./.
  );
}
