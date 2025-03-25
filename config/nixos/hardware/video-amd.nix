{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.amdvlk.enable = true;
  hardware.amdgpu.amdvlk.support32Bit.enable = true;
  hardware.amdgpu.initrd.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    "amdgpu.noretry=0" # Attempting to prevent `[drm:amdgpu_dm_atomic_commit_tail [amdgpu]] *ERROR* Waiting for fences timed out!`
  ];

  environment.variables.AMD_VULKAN_ICD = "RADV";

  primary-user.home-manager = {
    home.packages = [
      pkgs.amdgpu_top
      pkgs.vulkan-loader
      pkgs.vulkan-tools
      pkgs.glxinfo
      pkgs.radeon-profile
      pkgs.xorg.xdriinfo
    ];
  };

  primary-user.extraGroups = [ "video" ];

  # Workaround for https://gitlab.freedesktop.org/drm/amd/-/issues/1500
  services.udev.extraRules = ''
    KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
  '';
}
