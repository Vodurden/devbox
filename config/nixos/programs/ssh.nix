{ config, pkgs, ... }:

{
  programs.ssh.startAgent = true;

  primary-user.home-manager.programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
      };
    };

    # Workaround for "Unable to reach a settlement: [ssh-dss] and [ssh-rsa, rsa-sha2-512, rsa-sha2-256, ssh-ed25519]" in DataGrip
    #
    # See also: https://github.com/NixOS/nixpkgs/issues/13393#issuecomment-534846475 and https://superuser.com/a/1485062
    extraConfig = ''
      Host *
        HostKeyAlgorithms rsa-sha2-512,rsa-sha2-256,ssh-rsa,ssh-ed25519
    '';
  };
}
