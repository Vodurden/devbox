{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    mono6
    omnisharp-roslyn
  ];
}
