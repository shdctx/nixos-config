# Custom packages that aren't in nixpkgs, from pkgs/<name>/default.nix.
# Each one becomes available as pkgs.<name>, like an official package.
{
  nixpkgs.overlays = [
    (final: _prev: {
      anycubic-slicer-next = final.callPackage ../../../pkgs/anycubic-slicer-next { };
    })
  ];
}
