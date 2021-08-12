{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home-manager/base.nix
    ../../home-manager/intellij
    ../../home-manager/emacs
    ../../home-manager/vim
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jakew";
  home.homeDirectory = "/Users/jakew";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
