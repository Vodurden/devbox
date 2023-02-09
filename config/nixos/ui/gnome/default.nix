{ config, pkgs, ... }:

let
  gnomeExtensions = [
    {
      package = pkgs.gnomeExtensions.burn-my-windows;
      dconf = {
        apparition-open-effect = true;
        apparition-animation-time = 300;

        broken-glass-close-effect = true;
        broken-glass-animation-time = 1000;
        broken-glass-scale = 0.55;

        # Disable the defaults
        fire-close-effect = false;
        glide-close-effect = false;
      };
    }
    {
      package = pkgs.gnomeExtensions.compiz-windows-effect;
      dconf = {
        resize-effect = true;
        maximize-effect = false;
      };
    }
  ];

  gnomeExtensionsDconf = pkgs.lib.mkMerge (map (ext:
    {
      "org/gnome/shell/extensions/${ext.package.extensionPortalSlug}" = ext.dconf;
    }
  ) gnomeExtensions);
in

{
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-remote-desktop.enable = false;

  # Support QT apps but make them look like Gnome apps
  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita";

  environment.systemPackages = [
    pkgs.qt5.qtbase
    pkgs.qt5.qtwayland
  ];

  primary-user.home-manager = {
    imports = [ ./dconf.nix ];

    home.packages = [
      pkgs.gnome3.dconf-editor
      pkgs.dconf2nix
    ] ++ map (ext: ext.package) gnomeExtensions;

    # Enable our gnome extensions
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (ext: ext.package.extensionUuid) gnomeExtensions;
      };
    } // gnomeExtensionsDconf;
  };
}
