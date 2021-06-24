{ config, pkgs, lib, ... }:

let
  importAll = import ../../../../nix/lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;

  primary-user.home-manager.programs.direnv.enable = true;

  # Various terminal utilities that don't warrant a configuration file of their own
  primary-user.home-manager = {
    home.packages = [
      pkgs.ag
      pkgs.bat
      pkgs.du-dust
      pkgs.fd
      pkgs.pandoc
      pkgs.procs
      pkgs.proselint
      pkgs.plantuml
      pkgs.s-tui
      pkgs.tokei
      pkgs.unzip
      pkgs.vulkan-tools
    ];
  };
}
