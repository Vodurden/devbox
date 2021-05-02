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

  primary-user.home-manager = {
    # Loop Hero patches are only available on master.
    # TODO: Move to unstable when they get to unstable
    # TODO: Move to stable when they get to stable
    home.packages = [ pkgs.nixpkgs-master.steam ];
  };

}

