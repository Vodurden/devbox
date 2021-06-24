{ config, lib, pkgs, ... }:

let
  cfg = config.services.nintendo;
  kernelPackages = config.boot.kernelPackages;
in

with lib;

{
  options.services.nintendo = {
    enable = mkEnableOption "nintendo: support for nintendo controllers";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      kernelPackages.hid-nintendo
    ];

    boot.extraModulePackages = [ kernelPackages.hid-nintendo ];
    boot.kernelModules = [ "hid_nintendo" ];
  };
}
