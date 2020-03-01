{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix

    <nixos-hardware/common/cpu/intel/kaby-lake>

    ../../nix/system/base.nix
    ../../nix/system/gui.nix
    ../../nix/system/audio.nix
    ../../nix/system/laptop.nix
    ../../nix/system/games.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks = {
    reusePassphrases = true;
    devices = [
      {
        name = "root";
        device = "/dev/sdb2";
        preLVM = true;
      }
      {
        name = "media";
        device = "/dev/sda1";
        preLVM = true;
      }
    ];
  };

  networking.networkmanager.enable = true;
  networking.interfaces.enp109s0.useDHCP = true;
  networking.interfaces.wlp112s0.useDHCP = true;

  services.xserver.videoDrivers = ["nvidia"];

  services.thermald.configFile = ./thermald/thermal-conf.xml;

  hardware.pulseaudio.configFile = ./pulseaudio/default.pa;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  users.users.jake = {
    createHome = true;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
