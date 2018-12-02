{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix   # Include the results of the hardware scan.
      ../common.nix                 # Common across all of our nixos machines
    ];

  # Configuration below here should be specific to the laptop setup.
  # Everything else should be under common.nix

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelPackages = pkgs.linuxPackages_4_14;
  boot.kernelParams = ["video=SVIDEO-1:d"];

  networking.hostName = "jake-laptop"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

  # Laptop specific services:
  services.upower.enable = true;
  services.tlp.enable = true;

  services.thinkfan = {
    enable = true;
    sensor = "/sys/devices/virtual/hwmon/hwmon0/temp1_input";
  };

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    videoDrivers = ["modesetting"];

    displayManager.lightdm.enable = true;
    desktopManager.plasma5.enable = true;

    synaptics = {
      enable = true;
      palmDetect = true;
      twoFingerScroll = true;
      additionalOptions = ''
        Option "VertScrollDelta" "-100"
        Option "MinSpeed"   "0.7"
        Option "MaxSpeed"   "1.4"
        Option "AccelFactor"   "0.1"
      '';
    };
  };

  sound.mediaKeys.enable = true;

  environment.systemPackages = with pkgs; [
    steam
  ];
}
