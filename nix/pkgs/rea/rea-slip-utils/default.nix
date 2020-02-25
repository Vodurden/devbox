{ stdenv }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  baseName = "rea-slip-utils";
  name = "${baseName}-${version}";

  # Private modules work best with builtins.fetchGit instead of fetchgit. Make sure to use the `ssh://` style as it seems
  # to be the only one that works with your user's ssh config
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/cowbell/rea-slip-utils.git;
    rev = "1b6daf614f58f6be06cc0a5a92a6c028fae55a38";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin

    echo "Source is ${src}"
    echo "Out is $out"
    cp -r ${src}/bin/* "$out/bin"

    chmod a+x $out/bin/*
  '';
}
