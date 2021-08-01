{ config, lib, pkgs, ... }:

let
  nixpkgs-overlays = ../../../nix/overlays;
  load-overlay = overlay: import "${toString nixpkgs-overlays}/${overlay}";
  all-overlays = builtins.attrNames (builtins.readDir (toString nixpkgs-overlays));
in
{
  # We don't add overlays to NIX_PATH because it breaks `nix search`.
  nixpkgs.overlays = map load-overlay all-overlays;
}
