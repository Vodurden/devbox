{ config, lib, pkgs, ... }:

let
  importAll = import ../lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;
}
