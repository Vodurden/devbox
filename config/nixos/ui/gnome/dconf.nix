{ lib, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
  };
}
