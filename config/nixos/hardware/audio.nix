{ config, pkgs, lib, ... }:
{
  hardware.pulseaudio.enable = false;

  primary-user.home-manager = {
    home.packages = [
      pkgs.alsa-utils
      pkgs.pulseaudio # for pactl
      pkgs.helvum
      pkgs.pavucontrol
      pkgs.easyeffects
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    config.pipewire = {
      "context.properties" = {
        "log.level" = 3;
      };

    };

    config.pipewire-pulse = {
      "context.properties" = {
        "log.level" = 3;
      };
    };
  };
}
