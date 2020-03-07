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
    nixos-config = toString (./config/machines + "/${machine}" + /configuration.nix);
    nixpkgs-overlays = toString ./nix/overlays;

    build-nix-path-env-var = path:
      builtins.concatStringsSep ":" (
        pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
      );

    nix-path = build-nix-path-env-var {
      inherit
        nixos-config
        nixpkgs-overlays
        nixos-hardware
        home-manager
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
