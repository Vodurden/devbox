{ stdenv, lib }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  baseName = "aws-shortcuts";
  name = "${baseName}-${version}";

  # Private modules work best with builtins.fetchGit instead of fetchgit. Make sure to use the `ssh://` style as it seems
  # to be the only one that works with your user's ssh config
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/mbailey/aws-shortcuts.git;
    rev = "8efa25e9d7658543b0b4095bb5db1545389b1a40";
  };

  phases = "installPhase";

  installPhase = ''
    cp -r "${src}" $out
  '';

  meta = with lib; {
    description = "Simplifies AWS auth";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
