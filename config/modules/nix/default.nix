{ config, pkgs, ... }:

{
  imports = [
    ./nix-path.nix
    ./cachix.nix
    ./overlays.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = builtins.readFile ./nix.conf;
  };

  nixpkgs.config = import ./nixpkgs-config.nix;

  primary-user.home-manager = {
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
