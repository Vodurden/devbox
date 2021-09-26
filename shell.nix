{ machine }:

let
  sources = import ./nix/sources.nix;

  # nixpkgs-unstable-local = import ./nixpkgs {};
in
  with (import sources.nixpkgs-stable {});
  let
    nixpkgs-local-path = "${toString ./nixpkgs}";

    machine-path = ./config/machines + "/${machine}";
    machine-nixos-config = toString (machine-path + /configuration.nix);
    machine-home-manager-config = toString (machine-path + /home.nix);

    # nixpkgs-unstable-patched = applyPatches {
    #   name = "nixpkgs-unstable-patched";
    #   src = ./nixpkgs;
    #   patches = [
    #     # Fix steam proton: https://github.com/NixOS/nixpkgs/pull/129805
    #     # (fetchpatch {
    #     #   url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/129805.diff";
    #     #   sha256 = "0aq8cjjh84wg5sj0zi7ppsi5r2akh6w3zphqjglywzs0mhll6yyj";
    #     # })
    #   ];
    # };

    # Make sure to update ./config/modules/nix/nix-path.nix if changing this setting
    nix-path = builtins.concatStringsSep ":" [
      "nixpkgs=${nixpkgs-local-path}"
      "nixos-config=${machine-nixos-config}"
      "home-manager-config=${machine-home-manager-config}"
      "nixos-hardware=${sources.nixos-hardware}"
      "home-manager=${sources.home-manager}"
      "nixpkgs-stable=${sources.nixpkgs-stable}"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "nixpkgs-master=${sources.nixpkgs-master}"
    ];
  in
    mkShell {
      shellHook = ''
        export NIX_PATH="${nix-path}"
        export HOME_MANAGER_CONFIG="${machine-home-manager-config}"
      '';

      buildInputs = [
        (import sources.niv {}).niv
      ];
    }
