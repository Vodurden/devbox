{ machine }:

let
  sources = import ./nix/sources.nix;
  nixpkgs = sources.nixpkgs;
  home-manager = sources.home-manager;
  nixos-hardware = sources.nixos-hardware;
  nixpkgs-unstable = sources.nixpkgs-unstable;

in
  with (import nixpkgs {});
  let
    #####################################
    nixos-config = toString (./config/machines + "/${machine}" + /configuration.nix);
    nixpkgs-overlays = toString ./nix/overlays;

    build-nix-path-env-var = path:
      builtins.concatStringsSep ":" (
        pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
      );

    # Make sure to update ./config/modules/nix/nix-path.nix if changing this seteting
    nix-path = build-nix-path-env-var {
      inherit
        nixos-config
        nixpkgs-overlays
        nixos-hardware
        home-manager
        nixpkgs-unstable
        nixpkgs
        ;
    };
  in
    mkShell {
      shellHook = ''
        export NIX_PATH="${nix-path}"
      '';

      buildInputs = [
        (import sources.niv {}).niv
      ];
    }
