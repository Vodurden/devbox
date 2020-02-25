{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.aws-shortcuts;
in

{
  options.programs.aws-shortcuts = {
    enable = mkEnableOption "aws-shortcuts: authentication shortcuts for aws";
  };

  config = mkIf cfg.enable {
    home.file.".aws-shortcuts" = {
      recursive = true;
      source = pkgs.aws-shortcuts;
    };

    programs.bash.initExtra = ''
      if [ -e $HOME/.aws-shortcuts/iam-roles.txt ]; then
          source ${pkgs.aws-shortcuts}/aws-shortcuts.sh
      else
          echo "Cannot source `aws-shortcuts`: iam-roles.txt is missing."
          echo "To fix run:"
          echo ""
          echo "    rea-as okta > ~/.aws-shortcuts/iam-roles.txt"
          echo ""
      fi
    '';
  };
}
