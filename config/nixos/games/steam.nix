{ config, pkgs, lib, ... }:

{
  # Ports 27031, 27036 and 27037 are for steam in-home streaming
  # See: https://support.steampowered.com/kb_article.php?ref=3629-RIAV-1617#howdoiuseit
  networking.firewall = {
    allowedTCPPorts = [
      # Steam in-home streaming
      27036 27037

      # Borderlands 3
    ];

    allowedUDPPorts = [
      # Steam in-home streaming
      27031 27036

      # Borderlands 3
      7777 14001

      # Factorio
      34197
    ];

    allowedUDPPortRanges = [
      # Borderlands 3
      { from = 5795; to = 5847; }
    ];
  };

  programs.steam.enable = true;

  primary-user.home-manager.home.packages = [
    pkgs.protontricks
    pkgs.gamenix
  ];
}
