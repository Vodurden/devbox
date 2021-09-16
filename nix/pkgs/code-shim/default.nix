{ lib, pkgs, stdenv, ... }:

stdenv.mkDerivation rec {
  name = "code-shim";
  version = "1.0.0";

  src = ./.;

  buildPhase = ''
    gcc code-shim.c -o code
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv code $out/bin/code
  '';

  meta = {
    description = "code-shim provides a `code` binary that opens it's arguments, it can be used to trick Unity3d into thinking it is opening Visual Studio Code so it generates solution files";
    platforms = [ "x86_64-linux" ];
  };
}
