{ config, pkgs, ... }:

{
  services.xserver.libinput = {
    enable = true;
    tapping = false;             # Buttons for life
    naturalScrolling = true;     # Up is down, down is up!
    accelSpeed = "0.250000";
    accelProfile = "flat";

    # Only apply libinput settings to the touchpad
    #
    # See: https://github.com/NixOS/nixpkgs/issues/75007#issuecomment-617577348
    additionalOptions = ''MatchIsTouchpad "on"'';
  };
}
