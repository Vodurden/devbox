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
        type = types.enum [ "balance_performance" ];
        default = "balance_performance";
      };

      cpuNoTurbo = mkOption {
        type = types.bool;
        default = false;
        description = "If true, prevent the CPU from using turbo mode";
      };

      webcam = mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = "If false, disable the webcam";
      };

      fanProfile = mkOption {
        type = types.nullOr (types.enum ["Balanced" "Quiet" "Silent"]);
        default = null;
        description = "The fan profile, if null this setting will be ignored.";
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

  mkProfilesJson = profiles: builtins.toJSON (map mkProfileJson profiles);

  mkProfileJson = profile: {
    name = profile.name;
    display = if profile.displayBrightnessPct != null
              then { brightness = profile.displayBrightnessPct; useBrightness = true; }
              else { brightness = 100; useBrightness = false; };

    cpu = {
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
      type = lib.types.listOf profileConfig;
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
