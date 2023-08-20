{ lib, pkgs, ... }:

pkgs.pkgsCross.mingwW64.callPackage ./mo-redirector.nix {}
