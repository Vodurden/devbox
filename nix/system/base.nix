{ config, pkgs, lib, ...}:

{
  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  nixpkgs.config.allowBroken = true;

  # These values are bootstrapped from the root `shell.nix`. On subsequent runs they
  # will be set to themselves
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    nixos-config = toString <nixos-config>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
    nixos-hardware = toString <nixos-hardware>;
    home-manager = toString <home-manager>;
    nixpkgs = toString <nixpkgs>;
  };

  environment.variables.HOME_MANAGER_CONFIG = toString <home-manager-config>;

  nix.trustedUsers = [ "root" "jake" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    emacs
    rcm
    direnv
  ];

  services.lorri.enable = true;
}
