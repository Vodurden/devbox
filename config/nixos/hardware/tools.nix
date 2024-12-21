{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.lm_sensors
  ];

  programs.usbtop.enable = true;

  primary-user.home-manager = {
    home.packages = [
      pkgs.btop
      pkgs.inxi
      pkgs.phoronix-test-suite
      pkgs.pciutils
      pkgs.usbutils
    ];
  };
}
