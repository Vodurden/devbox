{ config, lib, pkgs, ... }:

let
  cfg = config.services.nintendo;
in

with lib;

{
  options.services.nintendo = {
    enable = mkEnableOption "nintendo: support for nintendo controllers";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.hid-nintendo
    ];

    boot.extraModulePackages = [ pkgs.hid-nintendo ];
    boot.kernelModules = [ "hid_nintendo" ];
  };
}
