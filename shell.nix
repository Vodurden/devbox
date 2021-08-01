{ machine }:

let
  sources = import ./nix/sources.nix;
in
  with (import sources.nixpkgs-stable {});
  let
    #####################################
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
    nix-path = builtins.concatStringsSep ":" [
      "nixpkgs=${nixpkgs-unstable-patched}"
      "nixos-config=${toString (./config/machines + "/${machine}" + /configuration.nix)}"
      "nixos-hardware=${sources.nixos-hardware}"
      "home-manager=${sources.home-manager}"
      "nixpkgs-stable=${sources.nixpkgs-stable}"
      "nixpkgs-unstable=${nixpkgs-unstable-patched}"
      "nixpkgs-master=${sources.nixpkgs-master}"
    ];
  in
    mkShell {
      shellHook = ''
        export NIX_PATH="${nix-path}"
      '';

      buildInputs = [
        (import sources.niv {}).niv
      ];
    }
