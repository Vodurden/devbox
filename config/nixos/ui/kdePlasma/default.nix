{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    exportConfiguration = true;
  };

  services.displayManager = {
    sddm.enable = true;
    autoLogin = {
      enable = true;
      user = "jake";
    };
  };

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  # Workaround to prevent almost-instant logout after auto-login
  # See: https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita";

  environment.systemPackages = [
    pkgs.qt5.qtbase
    pkgs.qt5.qtwayland
    pkgs.gnome-tweaks
    pkgs.adwaita-qt
  ];
}
