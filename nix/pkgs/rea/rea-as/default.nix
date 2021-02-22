{ stdenv, buildGoModule }:

buildGoModule rec {
  version = "2.0.6";
  baseName = "rea-as";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/cowbell/rea-as";

  vendorSha256 = "121b1sm8a3kn77ifk89dcsbd5rarwfah318184rwfx5cc929xzrp";

  # Private modules work best with builtins.fetchGit instead of fetchgit.
  # Make sure to use the `ssh://` style as it seems to be the only one that
  # works with your user's ssh config
  #
  # Note: When updating, first run `nixos-rebuild build` then `sudo -E nixos-rebuild switch`
  src = builtins.fetchGit {
    url = ssh://git@git.realestate.com.au/cowbell/rea-as.git;
    ref = "v2.0.6";
    rev = "44c498cdcbd811235dd3a005cbf103f14e56b4fb"; # v2.0.6
  };
}
