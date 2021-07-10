{ config, lib, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [
      pkgs.amdvlk
      pkgs.rocm-opencl-icd
      pkgs.rocm-opencl-runtime
    ];

    extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];
  };
  hardware.enableRedistributableFirmware = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [
    "amdgpu.noretry=0" # Attempting to prevent `[drm:amdgpu_dm_atomic_commit_tail [amdgpu]] *ERROR* Waiting for fences timed out!`
  ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.variables.AMD_VULKAN_ICD = "RADV";

  primary-user.home-manager = {
    home.packages = [
      pkgs.vulkan-tools
      pkgs.glxinfo
    ];
  };

  primary-user.extraGroups = [ "video" ];
}
