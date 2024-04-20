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
    {
      package = pkgs.gnomeExtensions.logo-menu;
      dconf = {
        menu-button-icon-image = 44; # NixOS Logo
        menu-button-icon-size = 22;
        menu-button-terminal = "termite";
      };
    }
    {
      package = pkgs.gnomeExtensions.rounded-window-corners;
      dconf = {};
    }
    {
      package = pkgs.gnomeExtensions.vitals;
      dconf = {};
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

    displayManager.autoLogin = {
      enable = true;
      user = "jake";
    };
  };

  # Workaround to prevent almost-instant logout after auto-login
  # See: https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.gnome.gnome-remote-desktop.enable = false;

  # Support QT apps but make them look like Gnome apps
  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style = "adwaita";

  environment.systemPackages = [
    pkgs.qt5.qtbase
    pkgs.qt5.qtwayland
    pkgs.gnome.gnome-tweaks
  ];

  primary-user.home-manager = {
    imports = [ ./dconf.nix ];

    home.packages = [
      pkgs.gnome3.dconf-editor
      pkgs.dconf2nix
    ] ++ map (ext: ext.package) gnomeExtensions;

    gtk.enable = true;
    # gtk.theme = { name = "Catppuccin-Dark"; package = pkgs.catppuccin-gtk; };
    # gtk.iconTheme = { name = "Tela-circle-dark"; package = pkgs.tela-circle-icon-theme; };
    gtk.gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk.gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    # Enable our gnome extensions
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (ext: ext.package.extensionUuid) gnomeExtensions ++ [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };
    } // gnomeExtensionsDconf;
  };
}
