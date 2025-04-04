{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.notion-app-enhanced
    pkgs.mame-tools # for chdman
    pkgs.mdf2iso
    pkgs.wiimms-iso-tools
    pkgs.gdb
    pkgs.discord
    pkgs.jujutsu
    pkgs.godot_4-mono
    pkgs.dotnet-sdk_8 # Needed for godot4-mono to work
    pkgs.tiled
  ];
}
