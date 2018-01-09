{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  baseName = "rea-slip-utils";
  name = "${baseName}-${version}";

  # Assumes we have run `nix-prefetch-git` as the soure is private:
  #
  #     nix-prefetch-git git@git.realestate.com.au:cowbell/rea-slip-utils.git v1.1.0 0bdw004w5z6vv53dpms7sv751wj0cg0zga4yisv31l5prlksj4pb
  #
  src = fetchgit {
    url = "git@git.realestate.com.au:cowbell/rea-slip-utils.git";
    rev = "v1.1.0";
    sha256 = "0bdw004w5z6vv53dpms7sv751wj0cg0zga4yisv31l5prlksj4pb";
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
