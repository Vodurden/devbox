{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.htop
      pkgs.ytop
    ];

    programs.bash.initExtra = ''
      alias top=ytop
    '';
  };
}
