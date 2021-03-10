{ config, pkgs, ... }:

{
  primary-user.home-manager = {
    programs.ssh.matchBlocks = {
      "git.realestate.com.au gist.git.realestate.com.au" = {
        extraOptions.StrictHostKeyChecking = "no";
        port = 65422;
        identitiesOnly = true;
      };

      "bastion.resi-product-prod-depth.realestate.com.au" = {
        extraOptions.StrictHostKeyChecking = "no";
        extraOptions.UserKnownHostsFile = "/dev/null";
        hostname = "bastion.resi-product-prod-depth.realestate.com.au";
        port = 22;
        user = "bastion";
        identityFile = "~/.ssh/resi-product-prod-ap-southeast-2";
      };

      "bastion.resi-product-prod-addons.realestate.com.au" = {
        extraOptions.StrictHostKeyChecking = "no";
        extraOptions.UserKnownHostsFile = "/dev/null";
        hostname = "bastion.resi-product-prod-addons.realestate.com.au";
        port = 22;
        user = "bastion";
        identityFile = "~/.ssh/resi-product-prod-ap-southeast-2";
      };
    };

    home.packages = with pkgs; [
      rea-as
      rea-slip-utils
      rea-cli
    ];

    programs.bash.initExtra = ''
      export REA_LDAP_USER=jake.woods
      export AWS_DEFAULT_REGION=ap-southeast-2

      # alias docker-login="rea-slip-docker-login && $(aws ecr get-login --region ap-southeast-2 --no-include-email --registry-ids 639347700193)"
    '';

    programs.aws-shortcuts.enable = true;
  };
}
