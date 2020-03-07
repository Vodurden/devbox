{ config, pkgs, ... }:

{
  services.xserver.libinput = {
    enable = true;
    tapping = false;             # Buttons for life
    naturalScrolling = true;     # Up is down, down is up!
    accelSpeed = "0.250000";
    accelProfile = "flat";
  };
}
