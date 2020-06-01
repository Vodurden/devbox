{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.unstable.zoom-us ];
}
