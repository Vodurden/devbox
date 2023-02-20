{ config, lib, pkgs, ... }:

{
  # Fancy startup animations
  boot.plymouth.enable = true;
  boot.plymouth.theme = "green_blocks";
  boot.plymouth.themePackages = [ pkgs.plymouth-adi1090x ];

  boot.initrd.systemd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Smooth transitions, workaround until real smooth transitions are provided
  # See: https://github.com/NixOS/nixpkgs/issues/32556#issuecomment-1378261367
  # See: https://github.com/NixOS/nixpkgs/issues/32556#issuecomment-1384554555
  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
