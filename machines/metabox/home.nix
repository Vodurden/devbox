{ config, pkgs, ... }:

{
  imports = [
    ../../nix/home/base.nix

    ../../nix/home/gui-xfce4

    ../../nix/home/aws.nix
    ../../nix/home/bash.nix
    ../../nix/home/direnv.nix
    ../../nix/home/games.nix
    ../../nix/home/git.nix
    ../../nix/home/termite.nix
    ../../nix/home/vim
    ../../nix/home/spacemacs
    ../../nix/home/syncthing
  ];

  programs.git.userEmail = "jake@jakewoods.net";

  home.packages = with pkgs; [
    thunderbird
  ];
}
