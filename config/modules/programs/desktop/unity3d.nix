{ config, lib, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.unityhub
      pkgs.code-shim
    ];
  };
}
