{ config, pkgs, lib, ... }:

{
  programs.home-manager = {
    enable = true;
    path = toString <home-manager>;
  };

  fonts.fontconfig.enable = true;
}
