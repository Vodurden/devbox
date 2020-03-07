{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = with pkgs; [
      awscli
    ];

    programs.bash-my-aws.enable = true;
  };
}
