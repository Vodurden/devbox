{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    programs.bash = {
      enable = true;

      initExtra = ''
        alias nixpkgs-build="nix-build -E \"with import <nixpkgs> {}; callPackage ./. {}\""
      '';
    };

    programs.readline = {
      enable = true;
      extraConfig = ''
        # Use vi bindings for navigating the terminal
        set editing-mode vi

        # Change the bash cursor depending on the vi mode
        set show-mode-in-prompt on
        set vi-cmd-mode-string "\1\x1b[\x32 q\2"
        set vi-ins-mode-string "\1\x1b[\x36 q\2"
      '';
    };
  };
}
