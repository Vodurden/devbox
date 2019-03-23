{ config, fetchgit, pkgs, pkgs_i686, ... }:

{
  imports =
    [
      ./hardware-configuration.nix   # Include the results of the hardware scan.
      ../common.nix                  # Common across all of our nixos machines
    ];

  # Configuration below here should be specific to the laptop setup.
  # Everything else should be under common.nix

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

  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.kernelModules = [
    "coretemp"
  ];

  # thermald needed CONFIG_POWERCAP and CONFIG_INTEL_RAPL and they don't seem to be on by default in NixOS
  boot.kernelPatches = [ {
    name = "rapl-config";
    patch = null;
    extraConfig = ''
      POWERCAP y
      INTEL_RAPL y
    '';
  }];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.
  hardware.pulseaudio.configFile = ./etc/pulse/default.pa;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  environment.systemPackages = with pkgs; [
    vulkan-loader
  ];

  networking.hostName = "jake-metabox"; # Define your hostname.
  networking.wireless.enable = true;

  # Ports 27031, 27036 and 27037 are for steam in-home streaming
  # See: https://support.steampowered.com/kb_article.php?ref=3629-RIAV-1617#howdoiuseit
  #
  # Ports 25565 are for minecraft servers
  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 25565 ];
    allowedUDPPorts = [ 27031 27036 25565 ];
  };

  # Enable X11
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    videoDrivers = ["nvidia"];

    displayManager.lightdm.enable = true;
    desktopManager.plasma5.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    synaptics.enable = true;
    synaptics.palmDetect = true;
    synaptics.twoFingerScroll = true;
    synaptics.tapButtons = false;
    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "MinSpeed"   "0.7"
      Option "MaxSpeed"   "1.4"
      Option "AccelFactor"   "0.1"
    '';
  };

  services.compton = {
    enable = true;
    backend = "xrender";
    vSync = "opengl";
  };

  services.samba = {
    enable = true;
  };

  # Laptop specific services:
  services.upower.enable = true;

  services.thermald = {
    enable = true;
    configFile = ./etc/thermald/thermal-conf.xml;
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_HWP_ON_AC=balance_performance
      CPU_HWP_ON_BAT=balance_power
      SCHED_POWERSAVE_ON_AC=1
      SCHED_POWERSAVE_ON_BAT=1
      ENERGY_PERF_POLICY_ON_AC=balance-performance
      ENERGY_PERF_POLICY_ON_BAT=balance-power
    '';
  };

  sound.enable = true;
  sound.enableOSSEmulation = false;
  sound.mediaKeys.enable = true;
}
