{ stdenv, buildGoModule }:

buildGoModule rec {
  version = "2.0.1";
  baseName = "rea-as";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/cowbell/rea-as";

  modSha256 = "1hyp2js69ysazrbfl853c3c4wkravvx9ylfjwp5pkf1ndmnk7i6a";

  # Private modules work best with builtins.fetchGit instead of fetchgit. Make sure to use the `ssh://` style as it seems
  # to be the only one that works with your user's ssh config
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/cowbell/rea-as.git;
    rev = "4afdf2c104c8ad5149f46f5dedf6ee94e0ebaf0a"; # v2.0.1
  };
}
