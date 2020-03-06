{ config, pkgs, ... }:

{
  # 22000/TCP: Syncthing listen port
  # 21027/UDP: Syncthing port for discovery broadcasts on IPv4 and multicasts on IPv6

  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 21027 ];
  };
}
