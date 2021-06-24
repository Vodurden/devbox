{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.htop
      pkgs.bottom
    ];

    programs.bash.initExtra = ''
      alias top=bottom
    '';
  };
}
