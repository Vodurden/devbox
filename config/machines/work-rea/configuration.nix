{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix

    <nixos-hardware/common/cpu/intel/kaby-lake>

    ../../modules/base.nix

    ../../modules/hardware/audio.nix
    ../../modules/hardware/battery.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/storage.nix
    ../../modules/hardware/cooling.nix
    ../../modules/hardware/network.nix
    ../../modules/hardware/touchpad.nix
    ../../modules/hardware/video-intel.nix

    ../../modules/languages
    ../../modules/programs
    ../../modules/games/steam.nix

    ../../modules/ui/xfce4
    ../../modules/ui/fonts.nix

    ../../modules/work/rea.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/sda2";
      preLVM = true;
    };
  };

  # Workarounds for issues on WPA Enterprise
  networking.networkmanager.dhcp = "dhclient";
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.dhcpcd.enable = true;

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  primary-user.name = "jake";
  primary-user.home-manager.programs.git.userEmail = "jake.woods@rea-group.com";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
