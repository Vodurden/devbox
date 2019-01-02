let
  unstable = import <nixpkgs-unstable> {};
in
{
  allowUnfree = true;
  allowBroken = true;

  packageOverrides = pkgs_: with pkgs_; {
    scalastyle = callPackage ./scalastyle {};
    rea-as = callPackage ./rea/rea-as {};
    aws-console-url = callPackage ./rea/aws-console-url {};
    rea-slip-utils = callPackage ./rea/rea-slip-utils {};

    nixosDevEnv = with pkgs; buildEnv {
      name = "nixos-dev-env";
      paths = [
        evince
        steam-run

        common
      ];
    };

    osxDevEnv = with pkgs; buildEnv {
      name = "osx-dev-env";
      paths = [
        postgresql
        hack-font

        common
      ];
    };

    wineStableEnv = with pkgs; buildEnv {
      name = "wine-stable-env";
      paths = [
        wine
        winetricks
      ];
    };

    wineUnstableEnv = with pkgs; buildEnv {
      name = "wine-unstable-env";
      paths = [
        wineWowPackages.unstable
        (winetricks.override {
          wine = wineWowPackages.unstable;
        })
      ];
    };

    node8Env = with pkgs; buildEnv {
      name = "node8-env";
      paths = [
        nodejs-8_x
        flow
        nodePackages.bower
        nodePackages.tern
        nodePackages.js-beautify
        nodePackages.eslint
        nodePackages.yarn
      ];
    };

    haskellEnv = with pkgs; buildEnv {
      name = "haskell-env";
      paths = [
        unstable.ghc
        unstable.cabal2nix
        unstable.cabal-install
        unstable.haskellPackages.hlint
        unstable.haskellPackages.stylish-haskell
        unstable.haskellPackages.hoogle
        unstable.haskellPackages.intero

        # The tests fail on OSX
        (unstable.haskellPackages.apply-refact.override {
          ghc-exactprint = (haskell.lib.dontCheck unstable.haskellPackages.ghc-exactprint);
        })
      ];
    };

    cppEnv = with pkgs; buildEnv {
      name = "c++-env";
      paths = [
        clang
      ];
    };

    scalaEnv = with pkgs; buildEnv {
      name = "scala-env";
      paths = [
        scala
        sbt
        scalastyle
        scalafmt
      ];
    };

    idrisEnv = with pkgs; buildEnv {
      name = "idris-env";
      paths = [
        unstable.idris
      ];
    };

    goEnv = with pkgs; buildEnv {
      name = "go-env";
      paths = [
        go
        go2nix
      ];
    };

    prologEnv = with pkgs; buildEnv {
      name = "prolog-env";
      paths = [
        gprolog
      ];
    };

    # Packages that should always be installed
    common = with pkgs; buildEnv {
      name = "common";
      paths = [
        coreutils
        nix-prefetch-git

        # Dotfile management
        rcm
        stdenv

        # Editors
        emacs
        vim
        vimPlugins.vundle

        # Environment management
        direnv

        # Java
        jdk

        # Ruby
        ruby

        # Tools
        awscli
        ag
        ncat
        ipcalc
        lzop
        jq
        jmespath
        gawk
        graphviz
        python36Packages.pydot
        unzip
        wget
      ];
    };
  };
}
