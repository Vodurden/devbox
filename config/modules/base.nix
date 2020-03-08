{ config, pkgs, lib, ... }:

let
  sources = import ../../nix/sources.nix;
  home-manager = import sources.home-manager {};
in

{
  imports = [
    ./nix

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

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    direnv
    ripgrep
    (import sources.cachix)
    (import sources.niv {}).niv
  ];


  services.lorri.enable = true;

  primary-user.home-manager = { config, ... }: {
    nixpkgs.config.allowUnfree = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}