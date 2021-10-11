{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli
  ];

  programs.bash-my-aws.enable = true;
}
