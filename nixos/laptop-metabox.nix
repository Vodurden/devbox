{ config, fetchgit, pkgs, pkgs_i686, ... }:

{
  imports =
    [
      ./hardware-configuration.nix   # Include the results of the hardware scan.
      ./common.nix                   # Common across all of our nixos machines
    ];

  # Configuration below here should be specific to the laptop setup.
  # Everything else should be under common.nix

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "mesa" "nouveau" "mesa-noglu" ];


  boot.kernelPackages = pkgs.linuxPackages_4_17;
  boot.kernelModules = [
    "coretemp"
  ];

  # acpi_mask_gpi - Resolves AE_NOT_FOUND (see https://superuser.com/a/1237529)
  boot.kernelParams = [
    "acpi_mask_gpe=0x6f"
    "acpi_osi=! \"acpi_osi=Windows 2009\""
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

  # i915 alpha_support=1  - Enables support for intel i915 graphics. Might not be needed with kernel >=4.15
  # iwlwifi 11n_disable=8 - Resolve occasional issue where the wifi fails to load on boot
  boot.extraModprobeConfig = ''
    options i915 alpha_support=1
    options snd-hda-intel model=no-primary-hp power_save=1
    options iwlwifi 11n_disable=8
  '';

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.optimus_prime.enable = true;
  hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.enableAllFirmware = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.

  environment.systemPackages = with pkgs; [
    vulkan-loader
  ];

  nix.nixPath = [
    "nixpkgs=/nix/nixpkgs"
    "nixpkgs-unstable=/nix/nixpkgs-unstable"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  networking.hostName = "jake-metabox"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    '';
  };

  # Laptop specific services:
  services.upower.enable = true;

  services.thermald = {
    enable = true;
    configFile = ./metabox/etc/thermald/thermal-conf.xml;
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_HWP_ON_AC=balance_power
      CPU_HWP_ON_BAT=balance_power
      SCHED_POWERSAVE_ON_AC=1
      SCHED_POWERSAVE_ON_BAT=1
      ENERGY_PERF_POLICY_ON_AC=balance_power
      ENERGY_PERF_POLICY_ON_BAT=balance_power
    '';
  };
  services.undervolt = {
    enable = true;
    coreOffset = "-110";
    gpuOffset = "-75";
    uncoreOffset = "-110";
    analogioOffset = "-110";
  };

  sound.enable = true;
  sound.enableOSSEmulation = false;
  sound.mediaKeys.enable = true;

  powerManagement.cpuFreqGovernor = pkgs.lib.mkForce null;
}
