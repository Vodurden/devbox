{ config, pkgs, ... }:

{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  services.xserver.videoDrivers = ["nvidia"];

  primary-user.extraGroups = [ "video" ];

  # RegistryDwords controls the performance of the GPU. We can use it to force certain performance levels and behaviors:
  #
  # - Quiet but stuck on Level 1:
  #   Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3333; PowerMizerDefault=0x2; PowerMizerDefaultAC=0x2"
  #
  # - Fast but stuck on max power:
  #   Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerDefault=0x1; PowerMizerDefaultAC=0x1"
  #
  services.xserver.deviceSection = ''
    Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x3333"
    Option "Coolbits" "31"
    Option "UseNvKmsCompositionPipeline" "Off"
    Option "TripleBuffer" "On"
  '';

  environment.variables."__GL_ExperimentalPerfStrategy" = "1";
}
