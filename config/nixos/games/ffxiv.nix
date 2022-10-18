{ config, lib, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [ pkgs.xivlauncher ];
  };
}
