{ config, pkgs, ... }:

{
  imports = [
    ../modules/home-manager/bash-my-aws.nix
    ../modules/home-manager/aws-shortcuts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
