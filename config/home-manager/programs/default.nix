{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.notion-app-enhanced
    pkgs.mame-tools # for chdman
    pkgs.mdf2iso
    pkgs.wiimms-iso-tools
    pkgs.gdb
    pkgs.godot_4
    (inputs.replugged-nix-flake.lib.makeDiscordPlugged {
      inherit pkgs;
    })
  ];
}
