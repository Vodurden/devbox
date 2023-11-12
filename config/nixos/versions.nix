{ config, lib, pkgs, ... }:

let
  versionOverlay = (self: super: {
    # Remove once https://github.com/NixOS/nixpkgs/pull/210737 is merged
    # xivlauncher = super.xivlauncher.overrideAttrs(prev: {
    #   version = "1.0.3";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "goatcorp";
    #     repo = "XIVLauncher.Core";
    #     rev = "1.0.3";
    #     hash = "sha256-aQVfW6Ef8X6L6hBEOCY/Py5tEyorXqtOO3v70mD7efA=";
    #     fetchSubmodules = true;
    #   };
    # });
  });
in {
  nixpkgs.overlays = [ versionOverlay ];
}
