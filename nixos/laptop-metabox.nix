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
  boot.kernelParams = [
    "acpi_mask_gpe=0x6f" # Resolves AE_NOT_FOUND (see https://superuser.com/a/1237529)
  ];
  boot.extraModprobeConfig = ''
    options i915 alpha_support=1
    options snd-hda-intel model=no-primary-hp power_save=1
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

  nix.nixPath = [
    "nixpkgs=/nix/nixpkgs"
    "nixpkgs-unstable=/nix/nixpkgs-unstable"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  #nixpkgs.config.packageOverrides = super: {
    # On the metabox the "Headpohne" line is actually a master audio controller. It needs
    # to always be set or audio won't work.
    #
    # This override prevents the headphones from being muted when the jack is unplugged
    #pulseaudioFull = super.pulseaudioFull.overrideAttrs (oldAttrs: rec {
      #postPtarget_pathhases = oldAttrs.postPhases ++ [ "metaboxHeadphoneHack" ];
      #postInstall = oldAttrs.postInstall + ''
      #  echo "it works!" > $out/proof
      #'';
    #});
  #};

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
  services.tlp.enable = true;

  sound.enable = true;
  sound.enableOSSEmulation = false;
  sound.mediaKeys.enable = true;

  powerManagement.enable = true;
}
