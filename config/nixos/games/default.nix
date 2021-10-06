{ lib, pkgs, ... }:

let
  importAll = import ../../../nix/lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;

  services.joycond.enable = true;

  primary-user.home-manager = {
    home.packages = [
      pkgs.lutris
      pkgs.minion
    ];
  };
}
