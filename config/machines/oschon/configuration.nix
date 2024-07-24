{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4

    ../../nixos/base.nix
    ../../nixos/hardware/audio.nix
    ../../nixos/hardware/bluetooth.nix
    ../../nixos/hardware/network.nix
    ../../nixos/hardware/nintendo.nix
    ../../nixos/hardware/storage.nix
    ../../nixos/hardware/tools.nix
    ../../nixos/hardware/video-amd.nix
    ../../nixos/hardware/xbox.nix

    ../../nixos/programs
    ../../nixos/games/ffxiv.nix
    ../../nixos/games/steam.nix

    ../../nixos/ui/gnome
    ../../nixos/ui/fonts.nix
    ../../nixos/ui/plymouth.nix

    ../../nixos/services/syncthing.nix
  ];

  primary-user.home-manager.imports = [
    ../../home-manager/base.nix

    ../../home-manager/terminal/base.nix
    ../../home-manager/terminal/aws.nix
    ../../home-manager/terminal/bash.nix
    ../../home-manager/terminal/termite.nix

    ../../home-manager/programs

    ../../home-manager/emacs
    ../../home-manager/lang/csharp.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576; # Steam Deck sets this high, it helps some games not crash
  };

  networking.hostName = "oschon"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false; # Workaround for qualcomm chip bug -- bad wifi performance

  primary-user.name = "jake";
  primary-user.home-manager.programs.git.userEmail = "jake@jakewoods.net";

  # Battery
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
