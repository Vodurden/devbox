# Copy of the official XIVLauncher package, occasionally updated faster when an urgent patch-day
# version upgrade is needed

{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, SDL2, libsecret, glib, gnutls, aria2, steam, gst_all_1
, copyDesktopItems, makeDesktopItem, makeWrapper
, useSteamRun ? true }:

buildDotnetModule rec {
  pname = "XIVLauncher";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "goatcorp";
    repo = "XIVLauncher.Core";
    rev = "072480ea658737362a7f3346d472f07237d0f457";
    sha256 = "sha256-x4W5L4k+u0MYKDWJu82QcXARW0zjmqqwGiueR1IevMk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  buildInputs = with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ];

  projectFile = "src/XIVLauncher.Core/XIVLauncher.Core.csproj";

# File generated with `nix-build -E "with import <nixpkgs> {}; (callPackage ./default.nix {}).passthru.fetch-deps" && ./result`
  nugetDeps = ./deps.nix;

  dotnetFlags = [
    "-p:BuildHash=1.0.8"
    "-p:PublishSingleFile=false"
  ];

  postPatch = ''
    substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Game/Patch/Acquisition/Aria/AriaHttpPatchAcquisition.cs \
      --replace 'ariaPath = "aria2c"' 'ariaPath = "${aria2}/bin/aria2c"'
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp src/XIVLauncher.Core/Resources/logo.png $out/share/pixmaps/xivlauncher.png
  '';

  postFixup = lib.optionalString useSteamRun (let
    steam-run = (steam.override {
      extraPkgs = pkgs: [ pkgs.libunwind ];
    }).run;
  in ''
    substituteInPlace $out/bin/XIVLauncher.Core \
      --replace 'exec' 'exec ${steam-run}/bin/steam-run'
  '') + ''
    wrapProgram $out/bin/XIVLauncher.Core --prefix GST_PLUGIN_SYSTEM_PATH_1_0 ":" "$GST_PLUGIN_SYSTEM_PATH_1_0"
    # the reference to aria2 gets mangled as UTF-16LE and isn't detectable by nix: https://github.com/NixOS/nixpkgs/issues/220065
    mkdir -p $out/nix-support
    echo ${aria2} >> $out/nix-support/depends
  '';

  executables = [ "XIVLauncher.Core" ];

  runtimeDeps = [ SDL2 libsecret glib gnutls ];

  desktopItems = [
    (makeDesktopItem {
      name = "xivlauncher";
      exec = "XIVLauncher.Core";
      icon = "xivlauncher";
      desktopName = "XIVLauncher";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = "XIVLauncher.Core";
    })
  ];

  meta = with lib; {
    description = "Custom launcher for FFXIV";
    homepage = "https://github.com/goatcorp/XIVLauncher.Core";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sersorrel witchof0x20 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "XIVLauncher.Core";
  };
}
