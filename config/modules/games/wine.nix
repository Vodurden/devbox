{ config, lib, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.wineWowPackages.full
      (pkgs.winetricks.override { wine = pkgs.wineWowPackages.full; })
    ];
  };
}
