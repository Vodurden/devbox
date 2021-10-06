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

  programs.evince.enable = true;

  primary-user.home-manager = {
    home.packages = [
      pkgs.aseprite-unfree
      pkgs.audacity
      pkgs.calibre
      pkgs.drawio
      # pkgs.discord -- broken, don't care
      pkgs.firefox
      pkgs.kdenlive
      pkgs.pinta
      pkgs.obsidian
      pkgs.slack
      pkgs.speedcrunch
      pkgs.spideroak
      pkgs.spotify
      pkgs.thunderbird
      pkgs.xournalpp
      pkgs.zoom-us
    ];
  };
}
