{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = ["intel"];
  services.xserver.deviceSection = ''
    Option "DRI" "3"
    Option "TearFree" "true"
  '';

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [
    pkgs.vaapiIntel
  ];

  primary-user.extraGroups = [ "video" ];
}
