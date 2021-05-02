{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = [
    pkgs.gradle
    pkgs.kotlin-language-server
  ];
}
