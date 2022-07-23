{
  stdenv,
  lib,
  pkgs,
  fetchFromGitHub,
  autoPatchelfHook,
  addOpenGLRunpath,
  cmake,
  pkg-config,
  boost,
  openssl,
  libopus,
  ffmpeg,
  libevdev,
  icu,
  libpulseaudio,
  avahi,
  mesa, # required for libgbm
  libglvnd, # i.e. libEGL

  xorg,

  wayland,

  libdrm,
  libcap
}:

# Adapted from: https://github.com/SunshineStream/Sunshine/discussions/181
stdenv.mkDerivation rec {
  pname = "sunshine";
  version = "0.14.0";

  src = fetchFromGitHub rec {
    owner = "sunshinestream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W9FzA8HCbHM4r2XNrZJejrqbPnNhT9x64cuVZpJRjHY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Fixes `cc1: error: '-Wformat-security' ignored without '-Wformat'`
    substituteInPlace ./third-party/cbs/CMakeLists.txt \
      --replace "-Wno-format" "-Wno-format -Wno-format-security"

    # Fixup hardcoded CMake paths
    substituteInPlace ./CMakeLists.txt \
      --replace "/usr/include/libevdev-1.0" "${libevdev}/include/libevdev-1.0" \
      --replace "/etc/udev/rules.d" "$out/etc/udev/rules.d" \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/lib/systemd/user" "$out/lib/systemd/user"
  '';

  # We can't use $out in `cmakeFlags` so we do it here
  preConfigure = ''
    cmakeFlags="$cmakeFlags -DSUNSHINE_ASSETS_DIR=$out/share/assets"
    cmakeFlags="$cmakeFlags -DSUNSHINE_CONFIG_DIR=$out/config"
  '';

  # We need `autoPatchelf` to run before `addOpenGLRunpath` so we disable the "auto" call and execute it below in `postFixup`
  dontAutoPatchelf = true;

  postFixup = ''
    autoPatchelf $out

    # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/add-opengl-runpath/setup-hook.sh
    addOpenGLRunpath $out/bin/sunshine
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
    addOpenGLRunpath
  ];

  buildInputs = [
    (boost.override { enableShared = false; }) # boost must be static
    openssl
    ffmpeg
    libopus
    libevdev
    icu
    libpulseaudio

    # X11: (SUNSHINE_ENABLE_X11)
    xorg.libX11
    xorg.libXfixes
    xorg.libXrandr

    # Wayland: (SUNSHINE_ENABLE_WAYLAND)
    wayland

    # kms: (SUNSHINE_ENABLE_DRM)
    libdrm
    libcap

    # omitted: cuda support (SUNSHINE_ENABLE_CUDA)
  ];

  runtimeDependencies = [ # used by autoPatchelfHook
    avahi
    mesa # libgbm
    libglvnd # i.e. libEGL
  ];

  meta = with lib; {
    description = "Sunshine is a Game stream host for Moonlight. It is an open source version of GeForce Experience (GFE).";
    homepage = "https://sunshinestream.readthedocs.io";
    changelog = "";
    license = with licenses; [gpl3];
  };
}
