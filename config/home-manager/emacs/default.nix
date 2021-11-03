{ config, pkgs, lib, inputs, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  home.packages = [
    pkgs.source-code-pro
    pkgs.etBook

    # for treemacs
    pkgs.python3

    # for doom module: nix
    pkgs.nixfmt

    # for doom module: sh
    pkgs.shellcheck

    # for org-roam
    pkgs.sqlite
    pkgs.graphviz

    # for org-download (i.e. +dragndrop)
    pkgs.xclip

    # for plantuml
    pkgs.plantuml

    # for text checking
    pkgs.proselint
  ];

  xdg.configFile."proselint/config".text = builtins.toJSON {
    checks = {
      # This causes a false positive with org-mode `TODO` blocks.
      "annotations.misc" = false;
    };
  };
}
