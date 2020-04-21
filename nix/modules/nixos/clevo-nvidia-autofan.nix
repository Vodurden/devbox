{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.clevo-nvidia-autofan;
in

{
  options.services.clevo-nvidia-autofan = {
    enable = mkEnableOption "clevo-nvidia-autofan: Better fan curve for clevo laptops with NVIDIA cards";
  };

  config = mkIf cfg.enable {
    systemd.services.clevo-nvidia-autofan = {
      description = "Clevo Nvidia Autofan";
      wantedBy = [ "graphical.target" ];
      partOf = [ "graphical.target" ];
      script = ''
        ${getBin config.boot.kernelPackages.nvidia_x11}/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader -l 3 | ${pkgs.clevo-indicator}/bin/clevo-indicator auto
      '';
    };
  };
}
