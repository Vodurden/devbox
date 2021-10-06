{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.bash-my-aws;
in

{
  options.programs.bash-my-aws = {
    enable = mkEnableOption "bash-my-aws: simple but powerful CLI commands for managing AWS resources";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli
      jq
      bash-my-aws
    ];

    # Every bash-my-aws command assumes it is installed under ~/.bash-my-aws which means we _need_ to link it there
    home.file.".bash-my-aws" = {
      recursive = true;
      source = pkgs.bash-my-aws;
    };

    programs.bash.initExtra = ''
      source ${pkgs.bash-my-aws}/aliases
    '';
  };
}
