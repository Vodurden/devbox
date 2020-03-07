{ config, pkgs, lib, ... }:

let
  sources = import ../../nix/sources.nix;
  home-manager = import sources.home-manager {};
in

{
  imports = [
    ./nix-path.nix

    home-manager.nixos # All machines support home-manager defined by configuration.nix

    ../../nix/modules
  ];

  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  # These values are bootstrapped from the root `shell.nix`. On subsequent runs they
  # will be set to themselves
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    nixos-config = toString <nixos-config>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
    nixos-hardware = toString <nixos-hardware>;
    home-manager = toString <home-manager>;
    nixpkgs = toString <nixpkgs>;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    direnv
    ripgrep
  ];

  services.lorri.enable = true;

  primary-user.home-manager = { config, ... }: {
    nixpkgs.config.allowUnfree = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
