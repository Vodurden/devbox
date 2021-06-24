{ config, pkgs, ... }:

{
#  networking.firewall = {
#    allowedTCPPorts = [ 22000 ]; # Syncthing listen port
#    allowedUDPPorts = [ 21027 ]; # Syncthing discovery broadcast port (IPv4) and multicast port (IPv6)
#  };
#
#  primary-user.home-manager = {
#    services.syncthing.enable = true;
#
#    home.packages = [ pkgs.syncthing-gtk ];
#
#    systemd.user.services = {
#      syncthing-gtk = {
#        Unit = {
#          Description = "Syncthing GTK UI";
#          Wants = ["syncthing.service"];
#          After = ["syncthing.service"];
#        };
#
#        Service = {
#          ExecStart = "${pkgs.syncthing-gtk}/bin/syncthing-gtk --minimized";
#          ExecStop = "${pkgs.syncthing-gtk}/bin/syncthing-gtk --quit";
#        };
#
#        Install = {
#          WantedBy = [ "graphical-session.target" ];
#        };
#      };
#    };
#  };
}
