{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../nixos/base.nix
    ../../nixos/hardware/tools.nix
    ../../nixos/hardware/audio.nix
    ../../nixos/hardware/bluetooth.nix
    ../../nixos/hardware/keyboard-g512
    ../../nixos/hardware/network.nix
    ../../nixos/hardware/storage.nix
    ../../nixos/hardware/video-amd.nix

    ../../nixos/programs
    ../../nixos/games

    ../../nixos/services/duplicati.nix
    ../../nixos/services/syncthing.nix

    ../../nixos/ui/gnome
    ../../nixos/ui/fonts.nix
  ];

  primary-user.home-manager.imports = [
    ../../home-manager/base.nix

    ../../home-manager/terminal/base.nix
    ../../home-manager/terminal/aws.nix
    ../../home-manager/terminal/bash.nix
    ../../home-manager/terminal/termite.nix

    ../../home-manager/emacs
    ../../home-manager/lang/csharp.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  services.joycond.enable = true;

  networking.hostName = "harpocrates"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  primary-user.name = "jake";
  primary-user.home-manager.programs.git.userEmail = "jake@jakewoods.net";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
