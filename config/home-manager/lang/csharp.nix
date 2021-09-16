{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    mono
    omnisharp-roslyn
  ];
}
