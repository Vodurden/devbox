{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.jetbrains.datagrip ];
}
