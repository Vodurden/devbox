{ config, pkgs, lib, ...}:

{
  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    nixos-config = toString <nixos-config>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
    nixos-hardware = toString <nixos-hardware>;
    nixpkgs = toString <nixpkgs>;
  };

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
