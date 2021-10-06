{ lib, ... }:

let
  importAll = import ../../../nix/lib/importAll.nix { inherit lib; };
  imports = importAll ./.;
in

{
  inherit imports;
}
