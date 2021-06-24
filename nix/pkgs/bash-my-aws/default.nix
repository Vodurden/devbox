{ stdenv, lib}:

stdenv.mkDerivation rec {
  version = "1.0.0";
  baseName = "bash-my-aws";
  name = "${baseName}-${version}";

  src = builtins.fetchGit {
    url = git://github.com/bash-my-aws/bash-my-aws;
    rev = "9a0c05f208aa2d1f17c51d30c2fecaba03c8850e";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir $out
    cp -r "${src}"/* "$out"
  '';

  meta = with lib; {
    description = "Bash-my-AWS provides simple but powerful CLI commands for managing AWS resources";
    homepage = https://bash-my-aws.org/;
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
