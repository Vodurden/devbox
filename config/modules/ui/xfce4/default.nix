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
    #
    # We also don't want to link _everything_ as some configuration shouldn't be shared
    home.activation.linkXfce4 = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xfce4-appfinder.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-appfinder.xml
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xfce4-desktop.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xfce4-panel.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xfwm4.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
      ln -sf ${toString ./xfconf/xfce-perchannel-xml/xsettings.xml} $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
    '';
  };
}
