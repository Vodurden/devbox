{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.v4l-utils
    pkgs.guvcview
  ];
}
