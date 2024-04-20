{ config, lib, pkgs, ... }:

{
  hardware.xone.enable = true;
  # hardware.xpadneo.enable = true; # Overrides deadzones

  primary-user.home-manager.home.packages = with pkgs; [
    pkgs.evtest
    pkgs.jstest-gtk
    pkgs.linuxConsoleTools # for evdev-joystick
    # pkgs.evdev-joystick-calibration -- broken on nixos 23.11, fix later maybe
  ];

  boot.kernelModules = [
    "xone-wired"
    # "xone-dongle"
    "xone-gip"
    # "xone-gip-gamepad"
    # "xone-gip-headset"
    # "xone-gip-chatpad"
    # "xone-gip-guitar"
  ];
}
