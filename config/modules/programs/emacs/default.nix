{ config, pkgs, lib, ... }:

{
  primary-user.home-manager = { config, ... }: {
    home.packages = [
      pkgs.emacs
    ];

    home.file.".emacs.d" = {
      recursive = true;
      source = (import ../../../../nix/sources.nix).spacemacs;
    };

    # We want a mutable link for spacemacs so we can edit the file in this repository
    home.activation.linkSpacemacs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf ${toString ./spacemacs} $HOME/.spacemacs
    '';
  };
}
