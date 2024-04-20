{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2024-04-16";
  baseName = "bash-my-aws";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "bash-my-aws";
    repo = "bash-my-aws";
    rev = "e2f24e7a38822bee3b8552ceb8f3a7d226f7343d";
    sha256 = "sha256-3hP2g9PIKnEVfF167hnRniMC5EOZQyKccM5ZNaGTIZ0=";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir $out
    cp -r "${src}"/* "$out"
  '';

  meta = with lib; {
    description = "Bash-my-AWS provides simple but powerful CLI commands for managing AWS resources";
    homepage = https://bash-my-aws.org/;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
