{ config, lib, pkgs, ... }:

{
    environment.systemPackages = [
      pkgs.kernelPackages.hid-nintendo
    ];

    boot.extraModulePackages = [ pkgs.kernelPackages.hid-nintendo ];
    boot.kernelModules = [ "hid_nintendo" ];
}
