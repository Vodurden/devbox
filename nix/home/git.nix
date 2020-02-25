{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jake Woods";
    extraConfig = {
      core.editor = "vim";
      push.default = "simple";
      rebase.autosquash = true;
    };
  };
}
