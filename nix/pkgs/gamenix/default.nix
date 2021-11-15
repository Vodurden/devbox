{ config, lib, pkgs, ... }:

let
  steam-proton-run = pkgs.callPackage ./steam-proton-run.nix {};
in

pkgs.buildEnv {
  name = "gamenix";
  paths = [ steam-proton-run ];
}
