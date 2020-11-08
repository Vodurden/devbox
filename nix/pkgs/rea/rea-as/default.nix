{ stdenv, buildGoModule }:

buildGoModule rec {
  version = "2.0.4";
  baseName = "rea-as";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/cowbell/rea-as";

  vendorSha256 = "1jxda5lqdhq1fvh58fmfjm2g61ic31zqyk4ihssd76ni15328pc0";

  # Private modules work best with builtins.fetchGit instead of fetchgit. Make sure to use the `ssh://` style as it seems
  # to be the only one that works with your user's ssh config
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/cowbell/rea-as.git;
    rev = "eba0aeeb840f71eb799beb905f1d42b16a2744cf"; # v2.0.4
  };
}
