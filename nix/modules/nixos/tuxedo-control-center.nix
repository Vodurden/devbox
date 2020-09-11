{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tuxedo-control-center;
in

{
  options.services.tuxedo-control-center = {
    enable = mkEnableOption "tuxedo-control-center: Better hardware control for TUXEDO laptops";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tuxedo-cc-wmi ];
    boot.extraModulePackages = [ pkgs.tuxedo-cc-wmi ];
    boot.kernelModules = [ "tuxedo-cc-wmi "];
  };
}
