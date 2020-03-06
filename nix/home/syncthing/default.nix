{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
  };

  home.packages = [
    pkgs.syncthing-gtk
  ];

  systemd.user.services = {
    syncthing-gtk = {
      Unit = {
        Description = "Syncthing GTK UI";
        Wants = ["syncthing.service"];
        After = ["syncthing.service"];
      };

      Service = {
        ExecStart = "${pkgs.syncthing-gtk}/bin/syncthing-gtk --minimized";
        ExecStop = "${pkgs.syncthing-gtk}/bin/syncthing-gtk --quit";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
