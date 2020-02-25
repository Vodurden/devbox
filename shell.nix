{ machine ? "work-rea" }:

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
    nixos-config = "./machines/${machine}/configuration.nix";
    nixpkgs-overlays = "./nix/overlays/";
    home-manager-config = "./machines/${machine}/home.nix";

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

    nixos-switch = pkgs.writeShellScriptBin "nixos-switch" ''
      nixos-rebuild switch
    '';

    home-manager-bin = pkgs.writeShellScriptBin "home-manager" ''
      $(nix-build '<home-manager>' -A home-manager --no-out-link)/bin/home-manager $@
    '';

    home-switch = pkgs.writeShellScriptBin "home-switch" ''
      home-manager -f "${home-manager-config}" switch
    '';

    files = "$(find . -name '*.nix' -not -wholename './nix/sources.nix')";
    lint = pkgs.writeShellScriptBin "lint" "nix-linter ${files}";
    format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt ${files}";

    switch-all = pkgs.writeShellScriptBin "switch-all" ''
      set -e
      lint
      format

      nixos-switch
      home-switch
    '';

  in
    mkShell {
      shellHook = ''
        export NIX_PATH="${nix-path}"
      '';

      buildInputs = [
        # Newer version of niv that should still be cached
        unstable.niv

        # darwin rebuild script and switch util
        nixos-switch

        # home-manager activation script and switch util
        home-manager-bin
        home-switch

        # Utils for lintinga nd formatting nix files in this repo
        unstable.nix-linter
        lint
        unstable.nixpkgs-fmt
        format

        # System (i.e. nixos && home-manager) switch util
        switch-all
      ];
    }
