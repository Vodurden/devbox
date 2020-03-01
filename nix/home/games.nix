{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam
    multimc
  ];
}
