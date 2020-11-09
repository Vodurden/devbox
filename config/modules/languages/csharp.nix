{ config, lib, pkgs, ... }:

{
  primary-user.home-manager.home.packages = with pkgs; [
    omnisharp-roslyn
  ];
}
