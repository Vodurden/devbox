{ config, pkgs, ... }:

{
  services.duplicati = {
    enable = true;
    user = config.primary-user.name;
  };

  # Type=Link desktop items don't seem to show up in Gnome 40, so let's work around it
  # by using Exec
  primary-user.home-manager.xdg.desktopEntries.duplicati = {
    name = "Duplicati";
    exec = "firefox 127.0.0.1:8200";
  };
}
