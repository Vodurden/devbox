{ pkgs, ... }:

{
  # Ports 27031, 27036 and 27037 are for steam in-home streaming
  # See: https://support.steampowered.com/kb_article.php?ref=3629-RIAV-1617#howdoiuseit
  #
  # Ports 25565 are for minecraft servers
  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 25565 ];
    allowedUDPPorts = [ 27031 27036 25565 ];
  };
}
