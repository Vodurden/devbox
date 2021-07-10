{ config, pkgs, lib, ... }:

let
  # alsa-lib-1251 = pkgs.alsa-lib.overrideAttrs (drv: {
  #   # NOTES:
  #   #
  #   # Since the store paths are replaced in the system closure, we can't use
  #   # "1.2.5.1" here because it would result in a different length.
  #   #
  #   # Additionally, the assertion here is to make sure that once version
  #   # 1.2.5.1 hits the system we get an error and can remove this altogether.
  #   version = assert pkgs.alsa-lib.version == "1.2.5"; "1.2.X";
  #   src = pkgs.fetchurl {
  #     url = "mirror://alsa/lib/${drv.pname}-1.2.5.1.tar.bz2";
  #     hash = "sha256-YoQh2VDOyvI03j+JnVIMCmkjMTyWStdR/6wIHfMxQ44=";
  #   };
  # });
in
{
  # Use pipewire from master until 0.3.31 is released
  # imports =  [
  #   <nixpkgs-master/nixos/modules/services/desktops/pipewire/pipewire.nix>
  #   <nixpkgs-master/nixos/modules/services/desktops/pipewire/pipewire-media-session.nix>
  # ];
  # disabledModules = [
  #   "services/desktops/pipewire/pipewire.nix"
  #   "services/desktops/pipewire/pipewire-media-session.nix"
  # ];

  nixpkgs.overlays = [
    (self: super: {
      # alsa-lib = super.alsa-lib.overrideAttrs (drv: {
      #   version = assert super.alsa-lib.version == "1.2.5"; "1.2.5.1";
      #   src = super.fetchurl {
      #     url = "mirror://alsa/lib/${drv.pname}-1.2.5.1.tar.bz2";
      #     hash = "sha256-YoQh2VDOyvI03j+JnVIMCmkjMTyWStdR/6wIHfMxQ44=";
      #   };
      # });

      # alsa-ucm-conf = super.alsa-ucm-conf.overrideAttrs (drv: {
      #   version = assert super.alsa-ucm-conf.version == "1.2.5"; "1.2.5.1";
      #   src = super.fetchurl {
      #     url = "mirror://alsa/lib/alsa-ucm-conf-1.2.5.1.tar.bz2";
      #     sha256 = "sha256-WEGkRBZty/R523UTA9vDVW9oUIWsfgDwyed1VnYZXZc=";
      #   };
      # });
    })
  ];

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
      };

      # package = pkgs.nixpkgs-master.pipewire.mediaSession;
      # package = pkgs.pipewire.override { alsa-lib = alsa-lib-1251; }.mediaSession;
    };

    # package = pkgs.nixpkgs-master.pipewire;

    # package = pkgs.pipewire.override {
    #   alsa-lib = alsa-lib-1251;
    # };
  };

  # system.replaceRuntimeDependencies = pkgs.lib.singleton {
  #   original = pkgs.alsa-lib;
  #   replacement = alsa-lib-1251;
  # };

  hardware.pulseaudio.enable = false;

  # primary-user.extraGroups = [ "audio" "pipewire" ];
  primary-user.home-manager = {
    home.packages = [
      pkgs.alsa-utils
      pkgs.pulseaudio # for pactl
      pkgs.helvum
      pkgs.pavucontrol
    ];
  };
}
