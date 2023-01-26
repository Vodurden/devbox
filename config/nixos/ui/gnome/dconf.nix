{ lib, ... }:

{
  # Use `dconf watch /` and edit the setting to see what changes
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
  };
}
