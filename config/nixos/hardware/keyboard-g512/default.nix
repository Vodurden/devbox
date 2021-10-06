{ config, pkgs, ... }:

{
  hardware.g810-led = {
    enable = true;

    # See: https://github.com/MatMoul/g810-led/tree/master/sample_profiles for profiles
    profile = ./g512-profile;

    enableFlashingWorkaround = true;
  };
}
