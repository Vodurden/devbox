{ config, lib, pkgs, ... }:

# Terminal utilties that we expect to always be installed regardless of environment

let
  shellAliases = {
    top = "bottom";
    nixpkgs-build = "nix-build -E \"with import <nixpkgs> {}; callPackage ./. {}\"";
  };
in

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    pkgs.bottom
    pkgs.bat
    pkgs.binutils
    pkgs.du-dust
    pkgs.fd
    pkgs.file
    pkgs.fzf
    pkgs.pandoc
    pkgs.procs
    pkgs.proselint
    pkgs.ripgrep
    pkgs.lsof
    pkgs.s-tui
    pkgs.tokei
    pkgs.unzip
  ];

  programs.zsh.shellAliases = shellAliases;
  programs.bash.shellAliases = shellAliases;
}
