{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix

    <nixos-hardware/common/cpu/intel/kaby-lake>

    ../../modules/base.nix

    ../../modules/hardware/audio.nix
    ../../modules/hardware/battery.nix
    ../../modules/hardware/cooling.nix
    ../../modules/hardware/network.nix
    ../../modules/hardware/touchpad.nix
    ../../modules/hardware/video-intel.nix

    ../../modules/programs

    ../../modules/ui/xfce4
    ../../modules/ui/fonts.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
    }
  ];

  # Workarounds for issues on WPA Enterprise
  networking.networkmanager.dhcp = "dhclient";
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.dhcpcd.enable = true;

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    jetbrains.datagrip
    zoom-us
  ];

  primary-user.name = "jake";

  primary-user.home-manager = {
    programs.git.userEmail = "jake.woods@rea-group.com";

    home.packages = with pkgs; [
      rea-as
      rea-slip-utils
    ];

    programs.bash.initExtra = ''
      export REA_LDAP_USER=jake.woods
      export AWS_DEFAULT_REGION=ap-southeast-2

      # alias docker-login="rea-slip-docker-login && $(aws ecr get-login --region ap-southeast-2 --no-include-email --registry-ids 639347700193)"
    '';

    programs.aws-shortcuts.enable = true;

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          identityFile = "~/.ssh/id_rsa";
        };

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
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
