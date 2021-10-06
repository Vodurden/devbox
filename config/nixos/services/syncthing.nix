{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 22000 ]; # Syncthing listen port
    allowedUDPPorts = [ 21027 ]; # Syncthing discovery broadcast port (IPv4) and multicast port (IPv6)
  };

  primary-user.home-manager = {
    services.syncthing.enable = true;
  };

  # Type=Link desktop items don't seem to show up in Gnome 40, so let's work around it by using Exec
  primary-user.home-manager.xdg.desktopEntries.syncthing = {
    name = "Syncthing";
    exec = "firefox 127.0.0.1:8384";
  };
}
