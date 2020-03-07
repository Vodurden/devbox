{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  primary-user.home-manager = {
    home.packages = [ pkgs.multimc ];
  };
}
