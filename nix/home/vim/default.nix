{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.vim-colors-solarized
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
