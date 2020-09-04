{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    home.packages = [
      pkgs.ytop
    ];

    # I never use `top` so lets alias `top` to `ytop`
    programs.bash.initExtra = ''
      alias top=ytop
    '';
  };
}
