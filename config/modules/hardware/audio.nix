{ config, pkgs, lib, ... }:
{
  system.replaceRuntimeDependencies = [
    {
      original = pkgs.alsa-lib;
      replacement = pkgs.alsa-lib.overrideAttrs (drv: {
        # NOTES:
        #
        # Since the store paths are replaced in the system closure, we can't use
        # "1.2.5.1" here because it would result in a different length.
        #
        # Additionally, the assertion here is to make sure that once version
        # 1.2.5.1 hits the system we get an error and can remove this altogether.
        version = assert pkgs.alsa-lib.version == "1.2.5"; "1.2.X";
        src = pkgs.fetchurl {
          url = "mirror://alsa/lib/${drv.pname}-1.2.5.1.tar.bz2";
          hash = "sha256-YoQh2VDOyvI03j+JnVIMCmkjMTyWStdR/6wIHfMxQ44=";
        };
      });
    }

    {
      original = pkgs.alsa-ucm-conf;
      replacement = pkgs.alsa-ucm-conf.overrideAttrs (drv: {
        # NOTES:
        #
        # Since the store paths are replaced in the system closure, we can't use
        # "1.2.5.1" here because it would result in a different length.
        #
        # Additionally, the assertion here is to make sure that once version
        # 1.2.5.1 hits the system we get an error and can remove this altogether.
        version = assert pkgs.alsa-ucm-conf.version == "1.2.5"; "1.2.X";
        src = pkgs.fetchurl {
          url = "mirror://alsa/lib/alsa-ucm-conf-1.2.5.1.tar.bz2";
          sha256 = "sha256-WEGkRBZty/R523UTA9vDVW9oUIWsfgDwyed1VnYZXZc=";
        };
      });
    }
  ];

  nixpkgs.overlays = [(self: super: {
    # We need the master version of pipewire for https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/d1c6114423708945cecb09fdce6c72b276665c60
    pipewire = super.pipewire.overrideAttrs (drv: {
      version = assert super.pipewire.version == "0.3.31"; "git";
      src = super.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "pipewire";
        rev = "a164e1d0a17549cc4c238cfe9c32a0bac97b24e1"; # 2021-07-12
        sha256 = "1dirz69ami7bcgy6hhh0ffi9gzwcy9idg94nvknwvwkjw4zm8m79";
      };
    });
  })];

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
