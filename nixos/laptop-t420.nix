{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix   # Include the results of the hardware scan.
      ./common.nix                   # Common across all of our nixos machines
    ];

  # Configuration below here should be specific to the laptop setup.
  # Everything else should be under common.nix

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelPackages = pkgs.linuxPackages_4_13;
  boot.kernelParams = ["video=SVIDEO-1:d"];

  networking.hostName = "jake-laptop"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Laptop specific services:
  services.upower.enable = true;
  services.tlp.enable = true;

  services.thinkfan = {
    enable = true;
    sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
  };

  services.xserver.synaptics = {
    enable = true;
    palmDetect = true;
    twoFingerScroll = true;
    additionalOptions = ''
      Option "VertScrollDelta" "-100"
    '';
  };

  sound.mediaKeys.enable = true;
}