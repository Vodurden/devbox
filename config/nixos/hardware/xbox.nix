{ config, lib, pkgs, ... }:

{
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;

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
