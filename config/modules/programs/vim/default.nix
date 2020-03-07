{ config, pkgs, ... }:

{
  primary-user.home-manager.programs.vim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.vim-colors-solarized
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
