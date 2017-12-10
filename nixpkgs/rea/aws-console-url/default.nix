{ stdenv, fetchgit, buildGoPackage }:

buildGoPackage rec {
  version = "1.0.0";
  baseName = "aws-console-url";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/david-yeung/aws-console-url";
  goDeps = ./deps.nix;

  # Assumes we have run `nix-prefetch-git` as the source is private:
  #
  #     nix-prefetch-git git@git.realestate.com.au:david-yeung/aws-console-url.git 620d18e5989afa9ed3cd4390bd7e441872f49bd6 1vh7c9wfhdc7amvan0wzywdsvqbj8csrpsbiz4r50n7xhv6alh5v
  #
  src = fetchgit {
    url = "git@git.realestate.com.au:david-yeung/aws-console-url.git";
    rev = "620d18e5989afa9ed3cd4390bd7e441872f49bd6";
    sha256 = "1vh7c9wfhdc7amvan0wzywdsvqbj8csrpsbiz4r50n7xhv6alh5v";
  };
}
