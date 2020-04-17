{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = [
    pkgs.ngrok
  ];
}
