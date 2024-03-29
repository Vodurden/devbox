{ config, lib, pkgs, ... }:

{
  programs.termite = {
    enable = true;
    font = "Hack 12";

    colorsExtra = ''
      # Base16 Solarized Dark
      # Author: Ethan Schoonover (http://ethanschoonover.com/solarized)

      foreground      = #93a1a1
      foreground_bold = #eee8d5
      cursor          = #eee8d5
      background      = #002b36

      # 16 color space

      # Black, Gray, Silver, White
      color0  = #002b36
      color8  = #657b83
      color7  = #93a1a1
      color15 = #fdf6e3

      # Red
      color1  = #dc322f
      color9  = #dc322f

      # Green
      color2  = #859900
      color10 = #859900

      # Yellow
      color3  = #b58900
      color11 = #b58900

      # Blue
      color4  = #268bd2
      color12 = #268bd2

      # Purple
      color5  = #6c71c4
      color13 = #6c71c4

      # Teal
      color6  = #2aa198
      color14 = #2aa198

      # Extra colors
      color16 = #cb4b16
      color17 = #d33682
      color18 = #073642
      color19 = #586e75
      color20 = #839496
      color21 = #eee8d5
    '';
  };
}
