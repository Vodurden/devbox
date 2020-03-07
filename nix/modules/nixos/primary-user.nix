# Stolen from: https://github.com/cprussin/dotfiles/blob/48a982faf799502d600fee3323f5929b72efacde/modules/nixos/primary-user.nix
{ config, lib, ... }:

let
  cfg = config.primary-user;
in

{
  options.primary-user.name = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The name of the primary user account.";
  };

  imports = [
    (lib.mkAliasOptionModule [ "primary-user" "home-manager" ] [ "home-manager" "users" cfg.name ])
    (lib.mkAliasOptionModule [ "primary-user" "home" ] [ "users" "users" cfg.name "home" ])
    (lib.mkAliasOptionModule [ "primary-user" "shell" ] [ "users" "users" cfg.name "shell" ])
    (lib.mkAliasOptionModule [ "primary-user" "extraGroups" ] [ "users" "users" cfg.name "extraGroups" ])
    (lib.mkAliasOptionModule [ "primary-user" "uid" ] [ "users" "users" cfg.name "uid" ])
    (lib.mkAliasOptionModule [ "primary-user" "openssh" ] [ "users" "users" cfg.name "openssh" ])
  ];

  config = lib.mkIf (cfg.name != null) {
    primary-user = {
      extraGroups = [ "wheel" ];
      uid = lib.mkDefault 1000;
    };
    users.users.${cfg.name}.isNormalUser = true;
    nix.trustedUsers = [ "root" cfg.name ];
  };
}
