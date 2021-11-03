{ config, inputs, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.doom-emacs;

  mkDoom = pkgs.callPackage ./mkDoom.nix {};
  myDoom = mkDoom {
    emacs = pkgs.emacsWithPackages (epkgs: [
      epkgs.vterm
    ]);

    doom = inputs.doom-emacs;
    doomLocalDir = "${config.xdg.dataHome}/doom";
  };
in

{
  options.programs.doom-emacs = {
    enable = mkEnableOption "doom-emacs";

    doomPrivateDir = mkOption {
      type = types.path;
      description = "Your doom configuration";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      myDoom

      pkgs.emacs-all-the-icons-fonts
    ];

    xdg.configFile."emacs" = {
      source = inputs.doom-emacs;
    };

    xdg.configFile."doom" = {
      source = cfg.doomPrivateDir;
    };

    services.emacs = {
      enable = true;
      package = myDoom;
      client = {
        enable = true;
      };
    };
  };
}
