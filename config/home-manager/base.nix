{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ../../nix/home-manager
  ];

  programs.home-manager = {
    enable = true;
    path = toString inputs.home-manager;
  };

  fonts.fontconfig.enable = true;

  home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";

  xdg.configFile."nix/nix.conf".source = ../nix/nix.conf;
  xdg.configFile."nixpkgs/config.nix".source = ../nix/nixpkgs-config.nix;

  # Eliminate channels and replace ~/.nix-defexpr with a symlink to nixpkgs, so `nix-env` uses a sane channel
  home.activation.eliminateChannelsRoot = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    rm -f $HOME/.nix-channels

    rm -rf $HOME/.nix-defexpr
    ln -sf ${inputs.nixpkgs} $HOME/.nix-defexpr
  '';
}
