{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.du-dust
    ];
  };
}
