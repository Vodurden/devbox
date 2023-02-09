{ config, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  # TODO: Find something to replace polymc
  primary-user.home-manager = {
    home.packages = [
      pkgs.prismlauncher
    ];
  };
}
