{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = [
    pkgs.texlive.combined.scheme-full
  ];
}
