{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  primary-user.extraGroups = [ "docker" ];
  primary-user.home-manager.home.packages = [
    pkgs.docker-compose
  ];
}
