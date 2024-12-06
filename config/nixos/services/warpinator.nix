{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 5353 42000 42001 ];
    allowedUDPPorts = [ 5353 42000 42001 ];
  };

  primary-user.home-manager = {
    home.packages = [
      pkgs.warpinator
    ];
  };
}
