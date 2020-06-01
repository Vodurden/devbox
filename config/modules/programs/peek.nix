{ config, pkgs, ... }:

{
  primary-user.home-manager.home.packages = with pkgs; [
    peek

    # Gifski enables the "High Quality Gif" feature of peek
    gifski
  ];
}
