{ machine }:

let
  sources = import ./nix/sources.nix;
in
  with (import sources.nixpkgs-stable {});
  let
    #####################################
    build-nix-path-env-var = path:
      builtins.concatStringsSep ":" (
        pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
      );

    nixpkgs-unstable-patched = applyPatches {
      name = "nixpkgs-unstable-patched";
      src = sources.nixpkgs-unstable;
      patches = [
        # Fix steam proton: https://github.com/NixOS/nixpkgs/pull/129805
        (fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/129805.diff";
          sha256 = "0aq8cjjh84wg5sj0zi7ppsi5r2akh6w3zphqjglywzs0mhll6yyj";
        })
      ];
    };

    # Make sure to update ./config/modules/nix/nix-path.nix if changing this setting
    nix-path = build-nix-path-env-var {
      nixpkgs = nixpkgs-unstable-patched;
      nixpkgs-unstable = sources.nixpkgs-unstable;
      nixpkgs-stable = sources.nixpkgs-stable;
      nixpkgs-master = sources.nixpkgs-master;
      nixos-hardware = sources.nixos-hardware;
      home-manager = sources.home-manager;
      nixos-config = toString (./config/machines + "/${machine}" + /configuration.nix);
      nixpkgs-overlays = toString ./nix/overlays;
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
