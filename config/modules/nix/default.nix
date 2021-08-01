{ config, pkgs, ... }:

{
  imports = [
    ./nix-path.nix
    ./cachix.nix
    ./overlays.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;

  primary-user.home-manager = {
    nixpkgs.config = config.nixpkgs.config;
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
