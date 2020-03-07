{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet

    # VPN support
    openconnect
    openssl
    gnome3.networkmanager-openconnect
  ];

  primary-user.extraGroups = [ "networkmanager" ];
}
