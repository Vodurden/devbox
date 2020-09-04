{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = [ pkgs.aseprite-unfree ];
}
