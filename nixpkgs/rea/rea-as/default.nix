{ stdenv, fetchgit, buildGoModule }:

buildGoModule rec {
  version = "1.5.3";
  baseName = "rea-as";
  name = "${baseName}-${version}";

  goPackagePath = "git.realestate.com.au/cowbell/rea-as";

  modSha256 = "19jjsakglqdx6sppfjjgypgngvk51sxbj6fdzhk028mb7nj9wkmj";

  # Assumes we have run `nix-prefetch-git` as the source is private:
  #
  #     nix-prefetch-git git@git.realestate.com.au:cowbell/rea-as.git 88337bfdf733248b533a945648cb5cbe5a07299e 1n8plr45ggyjyv0n509rz59c284hw75nzyf42j5bc2z6lp8gd8ln
  #
  src = fetchgit {
    url = "git@git.realestate.com.au:cowbell/rea-as.git";
    rev = "88337bfdf733248b533a945648cb5cbe5a07299e";
    sha256 = "1n8plr45ggyjyv0n509rz59c284hw75nzyf42j5bc2z6lp8gd8ln";
  };
}
