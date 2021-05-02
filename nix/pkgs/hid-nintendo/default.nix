# Stolen from: https://github.com/NixOS/nixpkgs/pull/108348/files
# Delete once this is merged into nixpkgs

{ lib, stdenv, fetchFromGitHub, linuxPackages }:

let
  kernel = linuxPackages.kernel;
in

stdenv.mkDerivation rec {
  pname = "hid-nintendo";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = "7faeb16c8aefdb1512f8283b8953b23fb3d19bb7";
    sha256 = "0whjipw82m9xjpk2r4knwlhkbafkdiwcazpv1wq0hw2pw4f3ccgi";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with stdenv.lib; {
    description = "A Nintendo HID kernel module";
    homepage = "https://github.com/nicman23/dkms-hid-nintendo";
    license = licenses.gpl2;
    maintainers = [ maintainers.rencire ];
    platforms = platforms.linux;
    broken = builtins.elem kernel.version ["libre" "4.4" "4.9"];
  };
}
