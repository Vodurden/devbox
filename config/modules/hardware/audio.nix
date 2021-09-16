{ config, pkgs, lib, ... }:
{
  hardware.pulseaudio.enable = false;

  primary-user.home-manager = {
    home.packages = [
      pkgs.alsa-utils
      pkgs.pulseaudio # for pactl
      pkgs.helvum
      pkgs.pavucontrol
      pkgs.nixpkgs-master.easyeffects
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

    media-session = {
      enable = true;
      config.media-session = {
        "context.properties" = {
          "log.level" = 3;
        };

        # TODO: Figure out how to apply profiles without pipewire freezing
        # "context.modules" = [{
        #   name = "libpipewire-module-filter-chain";
        #   args = {
        #     "node.name" = "effect_output.audioengine2";
        #     "node.description" = "Audio Engine 2 Sink";
        #     "media.name" = "Audio Engine 2 Sink";
        #     "filter.graph" = {
        #       nodes = [
        #         {
        #           type = "builtin";
        #           name = "eq_band_1";
        #           label = "bq_lowshelf";
        #           control = { "Freq" = 100.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_2";
        #           label = "bq_peaking";
        #           control = { "Freq" = 100.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_3";
        #           label = "bq_peaking";
        #           control = { "Freq" = 500.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_4";
        #           label = "bq_peaking";
        #           control = { "Freq" = 2000.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_5";
        #           label = "bq_peaking";
        #           control = { "Freq" = 5000.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_6";
        #           label = "bq_highshelf";
        #           control = { "Freq" = 5000.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #         {
        #           type = "builtin";
        #           name = "eq_band_7";
        #           label = "bq_highshelf";
        #           control = { "Freq" = 5000.0; "Q" = 1.0; "Gain" = 0.0; };
        #         }
        #       ];
        #       links = [
        #         { output = "eq_band_1:Out"; input = "eq_band_2:In"; }
        #         { output = "eq_band_2:Out"; input = "eq_band_3:In"; }
        #         { output = "eq_band_3:Out"; input = "eq_band_4:In"; }
        #         { output = "eq_band_4:Out"; input = "eq_band_5:In"; }
        #         { output = "eq_band_5:Out"; input = "eq_band_6:In"; }
        #         { output = "eq_band_6:Out"; input = "eq_band_7:In"; }
        #       ];
        #       inputs = [ "eq_band_1:In" ];
        #       outputs = [ "eq_band_7:Out" ];
        #     };
        #     "capture.props" = {
        #       "media.class" = "Audio/Sink";
        #       "audio.channels" = 2;
        #       "audio.position" = [ "FL" "FR" ];
        #     };
        #     "playback.props" = {
        #       "node.passive" = true;
        #       "audio.channels" = 2;
        #       "audio.position" = [ "FL" "FR" ];
        #       # "node.target" = "alsa_output.pci-0000_2a_00.4.analog-stereo";
        #     };
        #   };
        # }];
      };
    };
  };
}
