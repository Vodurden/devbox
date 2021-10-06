{ config, lib, pkgs, ... }:

{
  # We need samba for ntlm_auth
  services.samba = {
    enable = true;
    enableWinbindd = true;
  };

  primary-user.home-manager = {
    home.packages = [
      pkgs.wineWowPackages.full
      (pkgs.winetricks.override { wine = pkgs.wineWowPackages.full; })
    ];
  };
}
