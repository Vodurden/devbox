{ lib, pkgs, ... }:

let
  importAll = import ../../../nix/lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;

  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = 0;
  };

  primary-user.home-manager = {
    home.packages = [
      pkgs.lutris
      pkgs.minion
      pkgs.ffmt
    ];
  };
}
