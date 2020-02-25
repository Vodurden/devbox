{ config, pkgs, ...}:

{
  services.upower.enable = true;

  services.thermald.enable = true;

  boot.kernelModules = [
    "coretemp"
  ];

  # thermald needed CONFIG_POWERCAP and CONFIG_INTEL_RAPL and they don't seem to be on by default in NixOS
  boot.kernelPatches = [ {
    name = "rapl-config";
    patch = null;
    extraConfig = ''
      POWERCAP y
      INTEL_RAPL y
    '';
  }];

  services.xserver.libinput = {
    enable = true;
    tapping = false;             # Buttons for life
    naturalScrolling = true;     # Up is down, down is up!
    accelSpeed = "0.250000";
    accelProfile = "flat";
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_HWP_ON_AC=balance_performance
      CPU_HWP_ON_BAT=balance_power
      SCHED_POWERSAVE_ON_AC=1
      SCHED_POWERSAVE_ON_BAT=1
      ENERGY_PERF_POLICY_ON_AC=balance-performance
      ENERGY_PERF_POLICY_ON_BAT=balance-power
    '';
  };
}
