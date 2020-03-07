{ config, pkgs, ... }:

{
  services.gnome3.gnome-keyring.enable = true;

  environment.systemPackages = [ pkgs.gnome3.seahorse ];
}
