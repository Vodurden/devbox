{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sunshine;
in
{
  options.services.sunshine = {
    enable = mkEnableOption "enable sunshine";

    package = mkOption {
      type = types.package;
      default = pkgs.sunshine;
      defaultText = literalExpression "pkgs.sunshine";
    };

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User account under which sunshine runs.";
    };

    group = mkOption {
      type = types.str;
      default = "root";
      description = "Group under which sunshine runs.";
    };


    enableAutostart = mkEnableOption "auto-start sunshine";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [cfg.package];

    security.wrappers.sunshine = {
      source = "${cfg.package}/bin/sunshine";
      capabilities = "cap_sys_admin=+p";
      owner = "root";
      group = "root";
    };

    environment.systemPackages = [cfg.package];

    users.users."${cfg.user}".extraGroups = [ "input" ];

    # See: https://github.com/moonlight-stream/moonlight-docs/wiki/Setup-Guide#manual-port-forwarding-advanced
    networking.firewall = {
      allowedTCPPorts = [47984 47989 48010];
      allowedUDPPorts = [47998 47999 48000 48002 48010];
    };

    systemd.user.services.sunshine = mkIf cfg.enableAutostart {
      description = "Sunshine Gamestream Server for Moonlight";
      wantedBy="graphical-session.target";

      serviceConfig = {
        ExecStart = "${pkgs.sunshine}/bin/sunshine";
        CapabilityBoundingSet = ["CAP_SYS_ADMIN"];
      };
    };
  };
}
