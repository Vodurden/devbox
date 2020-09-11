{ linuxPackages, stdenv, fetchurl }:

let
  kernel = linuxPackages.kernel;
  kernelDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in

stdenv.mkDerivation rec {
  name = "tuxedo-cc-wmi-${version}-${kernel.version}";
  version = "0.1.6";

  src = builtins.fetchGit {
    url = git://github.com/tuxedocomputers/tuxedo-cc-wmi;
    rev = "897285bf1d17b2bbdd26c9da5f57850e4efa1ab0";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    make KDIR='${kernelDir}' all
  '';

  installPhase = ''
    install -v -D -m 644 src/tuxedo_cc_wmi.ko "$out/lib/modules/${kernel.modDirVersion}/extra/tuxedo_cc_wmi.ko"
  '';

  meta = {
    description = "This module provides an interface to controlling various functionality (mainly connected to the EC) through WMI.";
    homepage = https://github.com/tuxedocomputers/tuxedo-cc-wmi;
    license = stdenv.lib.licenses.gpl3;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
