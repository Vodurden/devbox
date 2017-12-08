{ stdenv, fetchgit, buildGoPackage }:

buildGoPackage rec {
  version = "1.3.4";
  baseName = "rea-as";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/cowbell/rea-as";

  # Assumes we have run `nix-prefetch-git` as the source is private:
  #
  #     nix-prefetch-git git@git.realestate.com.au:cowbell/rea-as.git e76e1cbfe7b8010f845e51379d3bbcd889dfe6c8 10ipnni2b68y36bxjnmy8y6jrrm26n1q84kl00pzsb19v4zjn9f7
  #
  src = fetchgit {
    url = "git@git.realestate.com.au:cowbell/rea-as.git";
    rev = "e76e1cbfe7b8010f845e51379d3bbcd889dfe6c8";
    sha256 = "10ipnni2b68y36bxjnmy8y6jrrm26n1q84kl00pzsb19v4zjn9f7";
  };
}
