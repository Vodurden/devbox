{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../nix/nixos
    ./versions.nix
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

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = builtins.readFile ../nix/nix.conf;
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  nixpkgs.config = import ../nix/nixpkgs-config.nix;

  # We want nix path to point to nixpkgs so `nix-shell` and friends still work and don't instead
  # try to use the channel-based nixpkgs (which are ancient)
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; }; # Make flake inputs available to home-manager

  # Remove root's obsolete use of nix channels and nix-defexpr
  #
  # Non-root is handled by the home-manager base config
  home-manager.users.root = { config, ... }: {
    home.stateVersion = "21.05";
    home.activation.eliminateChannelsRoot = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      rm -f $HOME/.nix-channels

      rm -rf $HOME/.nix-defexpr
      ln -sf ${inputs.nixpkgs} $HOME/.nix-defexpr
    '';
  };
}
