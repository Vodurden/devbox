{ config, pkgs, lib, ... }:

let
  sources = (import ../../../../nix/sources.nix);
  doom-emacs = sources.doom-emacs;
in

{
  primary-user.home-manager = { config, ... }: {
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.vterm
      ];
    };

    home.packages = [
      # for doom module: nix
      pkgs.nixfmt

      # for doom module: sh
      pkgs.shellcheck

      # for org-roam
      pkgs.sqlite
      pkgs.graphviz
      # for plantuml
      pkgs.plantuml
    ];

    home.file.".spacemacs.emacs.d" = {
      recursive = true;
      source = sources.spacemacs;
    };

    # emacs.d needs to be writable for doom emacs to work.
    home.activation.installDoom = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      # Link doom.d

      ln -sfT ${toString ./doom.d} $HOME/.doom.d

      if [ -d $HOME/.emacs.d ]; then
        # We want to preserve .local and .cache if they
        # exist since downloading these files takes a
        # long time.
        if [ -d $HOME/.emacs.d/.local ]; then
          rm -rf /tmp/.local
          mv $HOME/.emacs.d/.local /tmp/.local
        fi

        if [ -d $HOME/.emacs.d/.cache ]; then
          rm -rf /tmp/.cache
          mv $HOME/.emacs.d/.cache /tmp/.cache
        fi

        # We delete everything else to make sure the rest
        # of the files are from the version in nix
        rm -rf $HOME/.emacs.d
      fi

      mkdir -p $HOME/.emacs.d
      cp -r "${toString doom-emacs}"/* $HOME/.emacs.d/

      # Doom emacs needs the directory to be writable to work.
      #
      # If it didn't we could avoid this whole script!
      chmod -R +w $HOME/.emacs.d

      if [ -d /tmp/.local ]; then
        mv /tmp/.local $HOME/.emacs.d/.local
      fi

      if [ -d /tmp/.cache ]; then
        mv /tmp/.cache $HOME/.emacs.d/.cache
      fi

      $HOME/.emacs.d/bin/doom sync
    '';

    home.sessionVariables = {
      PATH = "$HOME/.emacs.d/bin:$PATH";
    };
  };
}
