{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.extraConfig = ''
    # Microphone background noise cancellation
    load-module module-echo-cancel
  '';

  sound.enable = true;
  sound.enableOSSEmulation = false;
  sound.mediaKeys.enable = true;

  primary-user.extraGroups = [ "audio" ];
}
