{ config, lib, pkgs, ... }:

{
  programs.bash.enable = true;
    # assert (lib.asserts.assertMsg (!(config.programs.zsh.enable)) "cannot enable bash and zsh");
    # true;

  programs.starship = {
    enable = true;
    settings = {
      aws = {
        disabled = true;
      };
      directory = {
        truncation_length = 8;
        truncation_symbol = "…/";
      };
    };
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      # Use vi bindings for navigating the terminal
      set editing-mode vi

      # Change the bash cursor depending on the vi mode
      set show-mode-in-prompt on
      set vi-cmd-mode-string "\1\x1b[\x32 q\2"
      set vi-ins-mode-string "\1\x1b[\x36 q\2"
    '';
  };
}
