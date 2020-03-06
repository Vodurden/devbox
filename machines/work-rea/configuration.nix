{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix

    <nixos-hardware/common/cpu/intel/kaby-lake>

    ../../nix/system/base.nix
    ../../nix/system/gui.nix
    ../../nix/system/audio.nix
    ../../nix/system/laptop.nix
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

  networking.networkmanager.enable = true;
  networking.networkmanager.dhcp = "dhclient";
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.dhcpcd.enable = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    jetbrains.datagrip
    slack
    zoom-us
  ];

  services.xserver.videoDrivers = ["intel"];
  services.xserver.deviceSection = ''
    Option "DRI" "2"
    Option "TearFree" "true"
  '';

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
