{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./nix
    ../../nix/modules
  ];

  # Internationalisation
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  i18n = {
    defaultLocale = "en_AU.UTF-8";
  };

  time.timeZone = "Australia/Sydney";

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    ripgrep
  ];


  services.lorri.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; }; # Make flake inputs available to home-manager

  primary-user.home-manager = { config, ... }: {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
