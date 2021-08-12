{ config, lib, pkgs, ... }:

{
  home.file.".ideavimrc".source = ./ideavimrc;
  home.file.".intellidoom" = {
    source = ./intellidoom;
    recursive = true;
  };
}
