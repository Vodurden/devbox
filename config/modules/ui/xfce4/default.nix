{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # XFCE4 Theme
    arc-theme
    faba-icon-theme

    # Better app launcher
    xfce4-14.xfce4-whiskermenu-plugin

    # The ability to lock the desktop
    xscreensaver
  ];

  services.xserver = {
    enable = true;
    exportConfiguration = true;

    displayManager.lightdm.enable = true;
    desktopManager.xfce4-14.enable = true;
  };

  services.compton = {
    enable = true;
  };

  primary-user.home-manager = { config, ... }: {
    # Make Super trigger WhiskerMenu (assumes Alt+F1 is bound to `xfce4-popup-whiskermenu`)
    services.xcape = {
      enable = true;
      mapExpression = {
        Super_L = "Alt_L|F1";
      };
    };

    # We want a mutable link for xfce4 config since _everything_ is done via a GUI
    home.activation.linkXfce4 = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      rm -rf $HOME/.config/xfce4/xfconf
      ln -sfn ${toString ./xfconf} $HOME/.config/xfce4/xfconf
    '';
  };
}
