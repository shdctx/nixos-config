# Anycubic Slicer Next: Anycubic's OrcaSlicer fork, repackaged from the
# official Ubuntu 24.04 .deb (Anycubic ships no other Linux build).
#
# Updating to a new version:
#   1. Find the newest entry in Anycubic's package index:
#        curl -s https://cdn-universe-slicer.anycubic.com/prod/dists/noble/main/binary-amd64/Packages
#      and copy its `Version` (without the "1:" prefix) and `Filename`.
#   2. Set `version` and `buildStamp` below from the new Filename
#      (…/AnycubicSlicerNext_linux-v<version>-<buildStamp>.deb).
#   3. Get the new hash and paste it into `hash`:
#        nix hash convert --hash-algo sha256 --to sri \
#          "$(nix-prefetch-url <url of the new .deb>)"
#   4. Test: nix build .#nixosConfigurations.shdctx.pkgs.anycubic-slicer-next
#      If the build reports libraries that "could not be satisfied", add the
#      nixpkgs packages that provide them to buildInputs.
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,
  webkitgtk_4_1,
  libsoup_3,
  gst_all_1,
  libpsl,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anycubic-slicer-next";
  version = "2.0.0.6";
  buildStamp = "20261030105113";

  src = fetchurl {
    url = "https://cdn-universe-slicer.anycubic.com/prod/pool/main/a/anycubicslicernext/AnycubicSlicerNext_linux-v${finalAttrs.version}-${finalAttrs.buildStamp}.deb";
    hash = "sha256-/bE0pOEfrX55XI1CVSDOEwUyHMwL8TdaZRoVE/iFRng=";
  };

  nativeBuildInputs = [
    dpkg # unpacks the .deb (dpkg-deb -x, run automatically)
    autoPatchelfHook # points the prebuilt binaries at NixOS's libraries
    wrapGAppsHook3 # GTK, icons, GSettings and GStreamer environment
    makeWrapper
  ];

  # Only what autoPatchelfHook reported as missing. GTK, GLib, Cairo, Pango,
  # X11, libstdc++ etc. already come with wrapGAppsHook3 and stdenv.
  buildInputs = [
    webkitgtk_4_1 # libwebkit2gtk-4.1, libjavascriptcoregtk-4.1 (embedded web pages)
    libsoup_3 # libsoup-3.0
    gst_all_1.gstreamer # libgstreamer-1.0, libgstbase-1.0
    gst_all_1.gst-plugins-base # libgstvideo-1.0
    libpsl # needed by Anycubic's bundled libcommon_log.so
  ];

  # Loaded at runtime (dlopen) instead of linked, so autoPatchelfHook can't
  # see it: libudev, used to detect USB drives
  runtimeDependencies = [ (lib.getLib systemd) ];

  # The wrapper is made by hand in postFixup, because the real binary doesn't
  # live in $out/bin (see installPhase)
  dontWrapGApps = true;

  # The .deb is laid out for /usr: usr/bin, usr/lib (Anycubic's own cloud and
  # printer libraries), usr/share. The program finds its resources at
  # /usr/share/AnycubicSlicerNext/resources, or else at
  # <its folder>/../../resources. NixOS has no /usr/share, so the binary goes
  # to $out/opt/anycubic-slicer-next/bin and the resources to $out/opt/resources.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/anycubic-slicer-next $out/bin
    cp -r usr/bin $out/opt/anycubic-slicer-next/bin
    cp -r usr/share/AnycubicSlicerNext/resources $out/opt/resources
    cp -r usr/lib $out/lib
    # Development files the app doesn't need
    rm -rf $out/lib/cmake $out/lib/*.a

    # Launcher entry and icon
    install -Dm444 usr/share/applications/AnycubicSlicer.desktop \
      $out/share/applications/anycubic-slicer-next.desktop
    substituteInPlace $out/share/applications/anycubic-slicer-next.desktop \
      --replace-fail "Icon=/usr/share/AnycubicSlicerNext/resources/images/AnycubicSlicer.png" \
                     "Icon=anycubic-slicer-next"
    install -Dm444 usr/share/AnycubicSlicerNext/resources/images/AnycubicSlicer.svg \
      $out/share/icons/hicolor/scalable/apps/anycubic-slicer-next.svg

    install -Dm444 usr/LICENSE.txt $out/share/doc/anycubic-slicer-next/LICENSE.txt

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/anycubic-slicer-next/bin/AnycubicSlicerNext \
      $out/bin/AnycubicSlicerNext \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Anycubic's slicer for its FDM 3D printers, based on OrcaSlicer";
    homepage = "https://github.com/ANYCUBIC-3D/AnycubicSlicerNext";
    license = lib.licenses.agpl3Only;
    mainProgram = "AnycubicSlicerNext";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
