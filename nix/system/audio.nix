{ config, pkgs, ...}:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;

  sound.enable = true;
  sound.enableOSSEmulation = false;
  sound.mediaKeys.enable = true;
}
