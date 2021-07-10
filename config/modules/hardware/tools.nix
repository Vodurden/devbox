{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.lm_sensors
  ];

  primary-user.home-manager = {
    home.packages = [
      pkgs.inxi
      pkgs.phoronix-test-suite
      pkgs.pciutils
      pkgs.usbutils
    ];
  };
}
