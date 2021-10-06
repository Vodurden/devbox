{ config, pkgs, lib, ... }:

{
  # We want:
  #
  # - NIX_PATH to be based on our sources managed in niv. No channels!
  # - To use <nixpkgs> for nix-env rather then whatever is in ~/.nix-defexpr
  # - To apply the above to both root and primary-user

  # These values are bootstrapped from `shell.nix`. On subsequent runs this simply sets each value to itself.
  # nix.nixPath = [
  #   "nixpkgs=${toString <nixpkgs>}"
  #   "nixos-config=${toString <nixos-config>}"
  #   "nixos-hardware=${toString <nixos-hardware>}"
  #   "home-manager=${toString <home-manager>}"
  #   "nixpkgs-stable=${toString <nixpkgs-stable>}"
  #   "nixpkgs-unstable=${toString <nixpkgs-unstable>}"
  #   "nixpkgs-master=${toString <nixpkgs-master>}"
  # ];

  # Eliminate channels and replace ~/.nix-defexpr with a symlink to <nixpkgs>
  primary-user.home-manager = { config, ... }: {
    home.activation.eliminateChannelsRoot = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      rm -f $HOME/.nix-channels

      rm -rf $HOME/.nix-defexpr
    '';
  };

  # Same as above, but for root
  home-manager.users.root = { config, ... }: {
    home.activation.eliminateChannelsRoot = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      rm -f $HOME/.nix-channels

      rm -rf $HOME/.nix-defexpr
    '';
  };
}
