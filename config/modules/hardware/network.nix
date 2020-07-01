{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet

    # VPN support
    openconnect
    openssl
    gnome3.networkmanager-openconnect
  ];

  primary-user.extraGroups = [ "networkmanager" ];
}
