{ machine }:

let
  sources = import ./nix/sources.nix;
  nixpkgs = sources.nixpkgs;
  home-manager = sources.home-manager;
  nixos-hardware = sources.nixos-hardware;
  unstable = import sources.nixpkgs-unstable {};

in
  with (import nixpkgs {});
  let
    #####################################
    nixos-config = toString (./machines + "/${machine}" + /configuration.nix);
    nixpkgs-overlays = toString ./nix/overlays;
    home-manager-config = toString (./machines + "/${machine}" + /home.nix);

    build-nix-path-env-var = path:
      builtins.concatStringsSep ":" (
        pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
      );

    nix-path = build-nix-path-env-var {
      inherit
        nixos-config
        nixpkgs-overlays
        nixos-hardware
        home-manager-config  # home-manager-config is only used to pass the correct path to `nix/system/base.nix`
        home-manager
        nixpkgs
        ;
    };
  in
    mkShell {
      shellHook = ''
        export NIX_PATH="${nix-path}"
        export HOME_MANAGER_CONFIG="${home-manager-config}"
      '';

      buildInputs = [
        (import sources.niv {}).niv
      ];
    }
