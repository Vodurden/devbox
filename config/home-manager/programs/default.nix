{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.notion-app-enhanced
    pkgs.mame-tools # for chdman
    pkgs.mdf2iso
    pkgs.wiimms-iso-tools
    (inputs.replugged-nix-flake.lib.makeDiscordPlugged {
      inherit pkgs;
    })
  ];
}
