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
    ../../modules/hardware/video-nvidia.nix
    ../../modules/hardware/keyboard-g512

    ../../modules/languages
    ../../modules/programs
    ../../modules/games

    ../../modules/ui/xfce4
    ../../modules/ui/fonts.nix

    ../../modules/work/rea.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks = {
    reusePassphrases = true;
    devices = {
      root = {
        device = "/dev/sdb2";
        preLVM = true;
      };

      media = {
        device = "/dev/sda1";
        preLVM = true;
      };
    };
  };

  # Clevo specific config
  services.tuxedo-control-center = {
    enable = true;
    acProfile = "NixOS";
    batteryProfile = "NixOS";
    profiles."NixOS" = {
      cpuGovernor = "powersave";
      cpuEnergyPerformancePreference = "balance_performance";
      fanProfile = "Silent";
    };
  };


  services.undervolt = {
    enable = true;
    coreOffset = -75;
    gpuOffset = -100;
  };

  networking.interfaces.enp109s0.useDHCP = true;
  networking.interfaces.wlp112s0.useDHCP = true;

  services.thermald.configFile = ./thermald/thermal-conf.xml;

  primary-user.name = "jake";
  primary-user.home-manager.programs.git.userEmail = "jake@jakewoods.net";

  # TODO: Remove this once upstream updates the go version
  nixpkgs.config.permittedInsecurePackages = [
    "go-1.14.15"
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
