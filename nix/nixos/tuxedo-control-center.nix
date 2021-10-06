{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tuxedo-control-center;

  profileConfig = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Name of this profile";
      };

      displayBrightnessPct = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "If non-null set the brightness of the laptop screen to this value";
      };

      cpuGovernor = mkOption {
        type = types.enum [ "powersave" ];
        default = "powersave";
      };

      cpuEnergyPerformancePreference = mkOption {
        type = types.str;
        default = "balance_performance";
        description = ''
          The energy performance preference that should be applied to your CPU when this profile is active.

          You can find the available performance profiles for your machine by executing:

              cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_available_preferences
        '';
      };

      cpuNoTurbo = mkOption {
        type = types.bool;
        default = false;
        description = "If true, prevent the CPU from using turbo mode";
      };

      cpuOnlineCores = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "The number of cores to enable when this profile is active. `null` implies no restriction.";
      };

      cpuScalingMinFrequency = mkOption {
        type = types.nullOr types.float;
        default = null;
        description = "The minimum CPU frequency allowed when this profile is active. `null` implies no restriction.";
      };

      cpuScalingMaxFrequency = mkOption {
        type = types.nullOr types.float;
        default = null;
        description = "The maximum CPU frequency allowed when this profile is active. `null` implies no restriction.";
      };

      webcam = mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = "If false, disable the webcam";
      };

      fanProfile = mkOption {
        type = types.nullOr (types.enum ["Silent" "Quiet" "Balanced" "Cool" "Freezy"]);
        default = null;
        description = ''
          The fan profile to use when this profile is active, if null this setting will be ignored.

          Valid profile names are derived from https://github.com/tuxedocomputers/tuxedo-control-center/blob/master/src/common/models/TccFanTable.ts
        '';
      };
    };
  };

  mkSettingsJson = acProfile: batProfile: builtins.toJSON {
    stateMap = {
      "power_ac" = acProfile;
      "power_bat" = batProfile;
    };
    shutdownTime = null;
  };

  mkProfilesJson = profiles: builtins.toJSON (lib.mapAttrsToList mkProfileJson profiles);

  mkProfileJson = name: profile: lib.filterAttrsRecursive (name: value: value != null) {
    name = name;
    display = if profile.displayBrightnessPct != null
              then { brightness = profile.displayBrightnessPct; useBrightness = true; }
              else { brightness = 100; useBrightness = false; };

    cpu = {
      onlineCores = profile.cpuOnlineCores;
      scalingMinFrequency = profile.cpuScalingMinFrequency;
      scalingMaxFrequency = profile.cpuScalingMaxFrequency;
      governor = profile.cpuGovernor;
      energyPerformancePreference = profile.cpuEnergyPerformancePreference;
      noTurbo = profile.cpuNoTurbo;
    };

    webcam = if profile.webcam != null
             then { status = profile.webcam; useStatus = true; }
             else { status = true; useStatus = false; };

    fan = if profile.fanProfile != null
          then { fanProfile = profile.fanProfile; useControl = true; }
          else { fanProfile = "Balanced"; useControl = false; };
  };
in

{
  options.services.tuxedo-control-center = {
    enable = mkEnableOption "tuxedo-control-center: Better hardware control for TUXEDO laptops";

    batteryProfile = mkOption {
      type = types.str;
      default = "Default";
      description = ''
        Name of the profile to use when on battery power

        Built in profiles are "Default", Cool and breezy" and "Powersave extreme"
      '';
    };

    acProfile = mkOption {
      type = types.str;
      default = "Default";
      description = ''
        Name of the profile to use when connected to power

        Built in profiles are "Default", Cool and breezy" and "Powersave extreme"
      '';
    };

    profiles = mkOption {
      type = lib.types.attrsOf profileConfig;
      default = [];
      description = ''
        The additional profiles available to Tuxedo Control Center.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.tuxedo-cc-wmi
      pkgs.tuxedo-control-center
    ];

    environment.etc."tcc/profiles".text = mkProfilesJson cfg.profiles;

    environment.etc."tcc/settings".text =
      mkSettingsJson cfg.acProfile cfg.batteryProfile;

    boot.extraModulePackages = [ pkgs.tuxedo-cc-wmi ];
    boot.kernelModules = [ "tuxedo-cc-wmi "];

    services.dbus.packages = [ pkgs.tuxedo-control-center ];

    systemd.services.tccd = {
      path = [ pkgs.tuxedo-control-center ];

      description = "TUXEDO Control Center Service";

      # Apply undervolt on boot, nixos generation switch and resume
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tuxedo-control-center}/bin/tccd --start";
        ExecStop = "${pkgs.tuxedo-control-center}/bin/tccd --stop";
      };
    };

    systemd.services.tccd-sleep = {
      path = [ pkgs.tuxedo-control-center ];

      description = "TUXEDO Control Center Service (sleep/resume)";

      # Apply undervolt on boot, nixos generation switch and resume
      wantedBy = [ "sleep.target" ];

      unitConfig = {
        StopWhenUnneeded="yes";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit="yes";
        # TODO: Do we need bash -c "systemctl stop tccd" here instead?
        ExecStart = "systemctl stop tccd";
        ExecStop = "systemctl start tccd";
      };
    };
  };
}
