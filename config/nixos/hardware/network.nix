{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  services.expressvpn.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet

    # VPN support
    openconnect
    openssl
    gnome3.networkmanager-openconnect
    expressvpn
  ];

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  primary-user.extraGroups = [ "networkmanager" ];
}
