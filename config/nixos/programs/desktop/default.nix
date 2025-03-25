{ config, pkgs, lib, ... }:

let
  importAll = import ../../../../nix/lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;

  # Various desktop programs that don't warrant a configuration file of their own
  environment.systemPackages = [
    pkgs.jetbrains.datagrip

    # Dictionaries only work if this is in systemPackages
    pkgs.libreoffice
  ];

  primary-user.home-manager = {
    home.packages = [
      pkgs.aseprite-unfree
      pkgs.audacity
      pkgs.calibre
      pkgs.drawio
      pkgs.firefox
      pkgs.pinta
      pkgs.slack
      pkgs.speedcrunch
      pkgs.spotify
      pkgs.thunderbird
      pkgs.xournalpp
      pkgs.zathura
      pkgs.zoom-us
    ];
  };
}
