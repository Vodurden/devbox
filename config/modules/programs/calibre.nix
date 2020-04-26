{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
