# Inspired by the dxvk packaging https://github.com/NixOS/nixpkgs/tree/8ff7b290e6dd47d7ed24c6d156ba60fc3c83f100/pkgs/misc/dxvk
{ stdenv, lib, pkgs, windows, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mo2-steam-redirector";
  version = "4.3.0";

  src = fetchFromGitHub rec {
    owner = "rockerbacon";
    repo = "modorganizer2-linux-installer";
    rev = "${version}";
    sparseCheckout = ''
      steam-redirector/
    '';
    sha256 = "sha256-vhW40h/yQz1rGzfdlFy6XSqebAsKQ+kl+4/roGL/dpg=";
  };

  buildInputs = [
    windows.pthreads
  ];

  sourceRoot = "source/steam-redirector";

  installPhase = ''
    mkdir -p $out/bin
    mv main.exe $out/bin/mo2-redirector.exe
  '';

  meta = with lib; {
    description = "Small program designed to trick the Steam Client into running an arbitrary executable when launching a specific game.";
    inherit (src.meta) homepage;
    platforms = lib.platforms.windows;
  };
}
