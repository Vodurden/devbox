{ config, ... }:

{
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
}
