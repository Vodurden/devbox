{ config, pkgs, lib, inputs, ... }:

# Parts of this are stolen from https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix
#
# We do this because nix-doom-emacs is defunct, so lets copy the author of
# doom emacs instead.
let
  doomRepoUrl = "https://github.com/doomemacs/doomemacs";
in
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = "graphical";
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

  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  home.activation.installDoom = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${config.xdg.configHome}/emacs" ]; then
          git clone --depth=1 --single-branch "${doomRepoUrl}" "${config.xdg.configHome}/emacs"
      fi
  '';

  # Need https://github.com/nix-community/home-manager/issues/4692 to fix
  #
  # xdg.configFile."doom".source =
  #   config.lib.file.mkOutOfStoreSymlink
  #     "${config.home.homeDirectory}/devbox/config/home-manager/emacs/doom.d";

  # Remove once mkOutOfStoreSymlink is fixed
  home.activation.updateLinks = ''
      ln -sf "${config.home.homeDirectory}/devbox/config/home-manager/emacs/doom.d" ${config.xdg.configHome}/doom
  '';
}
