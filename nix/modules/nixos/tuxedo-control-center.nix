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
    environment.systemPackages = [
      pkgs.tuxedo-cc-wmi
      pkgs.tuxedo-control-center
    ];

    boot.extraModulePackages = [ pkgs.tuxedo-cc-wmi ];
    boot.kernelModules = [ "tuxedo-cc-wmi "];

    services.dbus.packages = [ pkgs.tuxedo-control-center ];

    systemd.services.tccd = {
      path = [ pkgs.tuxedo-control-center ];

      description = "TUXEDO Control Center Service";

      # Apply undervolt on boot, nixos generation switch and resume
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tuxedo-control-center}/bin/tccd --start";
        ExecStop = "${pkgs.tuxedo-control-center}/bin/tccd --stop";
      };
    };

    systemd.services.tccd-sleep = {
      path = [ pkgs.tuxedo-control-center ];

      description = "TUXEDO Control Center Service (sleep/resume)";

      # Apply undervolt on boot, nixos generation switch and resume
      wantedBy = [ "sleep.target" ];

      unitConfig = {
        StopWhenUnneeded="yes";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit="yes";
        # TODO: Do we need bash -c "systemctl stop tccd" here instead?
        ExecStart = "systemctl stop tccd";
        ExecStop = "systemctl start tccd";
      };
    };
  };
}
