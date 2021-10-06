{ config, pkgs, lib, ... }:

{
  imports = [
    ../../nix/home-manager
  ];

  programs.home-manager = {
    enable = true;
    path = toString <home-manager>;
  };

  home.sessionVariables.HOME_MANAGER_CONFIG = toString <home-manager-config>;

  fonts.fontconfig.enable = true;
}
