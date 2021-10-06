{ stdenv, fetchgit, fetchFromGitHub, cmake, xxd }:

let
  zydisMasterSrc = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "c5f5bcf3536db9686934364b28253a08fbf10f12";
    sha256 = "sha256-TeCrkIJLVnujWeAPHtK6UULtYXKYWSNZFPwtzyEG9Tg=";
    fetchSubmodules = true;
  };

  zycoreMasterSrc = "${zydisMasterSrc}/dependencies/zycore";

  zydisMaster = stdenv.mkDerivation rec {
    pname = "zydis";
    version = "master-2021-10-05";
    src = zydisMasterSrc;

    nativeBuildInputs = [ cmake ];

    preBuild = ''
      rm -f ./ZydisExportConfig.h
      cp ${./ZydisExportConfig.h} ./ZydisExportConfig.h
    '';
  };

  zycoreMaster = stdenv.mkDerivation rec {
    pname = "zycore";
    version = "master-2021-10-05";
    src = zycoreMasterSrc;

    nativeBuildInputs = [ cmake ];

    preBuild = ''
      rm -f ./ZycoreExportConfig.h
      cp ${./ZycoreExportConfig.h} ./ZycoreExportConfig.h
    '';
  };
in

stdenv.mkDerivation {
  name = "e9patch";
  src = fetchgit {
    url = https://github.com/GJDuck/e9patch.git;
    rev = "be65ee50cf7efbd00f70bedb50b38de9f0e4abaf";
    sha256 = "sha256-yqtyQvUKlSDyEJ4TCsLxZ27fq2k5N3u29N6UD9UjRD8=";
  };

  buildInputs = [ zydisMaster zycoreMaster xxd ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "-I zydis/dependencies/zycore/" "-I ${zycoreMaster}/" \
      --replace "-I zydis/" "-I ${zydisMaster}/" \
      --replace "libZydis.a" "${zydisMaster}/lib/libZydis.a"
  '';

  buildPhase = ''
    make tool release
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ./e9patch $out/bin
    install -m 755 ./e9tool $out/bin
    install -m 755 ./e9compile.sh $out/bin/e9compile
  '';
}
