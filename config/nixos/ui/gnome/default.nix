{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-remote-desktop.enable = false;

  # Support QT apps but make them look like Gnome apps
  qt5.enable = true;
  qt5.platformTheme = "gnome";
  qt5.style = "adwaita";

  environment.systemPackages = [
    pkgs.qt5.qtbase
    pkgs.qt5.qtwayland
  ];

  primary-user.home-manager = {
    imports = [ ./dconf.nix ];

    home.packages = [
      pkgs.gnome3.dconf-editor
      pkgs.dconf2nix
    ];
  };
}
