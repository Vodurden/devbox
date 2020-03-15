{ config, pkgs, ... }:

{
  primary-user.home-manager.programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_rsa";
      };
    };
  };
}
