{ config, lib, pkgs, ... }:

{
  programs.adb.enable = true;

  primary-user.extraGroups = [ "adbusers" ];

  primary-user.home-manager = {
    home.packages = [
      pkgs.android-studio
    ];
  };
}
