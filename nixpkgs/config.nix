let
  unstable = import <nixos-unstable> {};
in {
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
        glibc.static

        # C/C++. We don't want this on OSX as we want to rely on apple's distribution
        gcc
        clang

        # apply-refact doesn't seem to compile on osx
        haskellPackages.apply-refact

        # scalafmt is marked as linux only for some reason
        scalafmt

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

    common = with pkgs; buildEnv {
      name = "all";

      paths = [
        nix-prefetch-git

        # Dotfile management
        rcm

        stdenv

        # Editors
        emacs
        vim
        vimPlugins.vundle

        # Haskell
        unstable.ghc
        unstable.stack
        haskellPackages.hlint
        haskellPackages.stylish-haskell
        haskellPackages.hasktags
        haskellPackages.hoogle
        haskellPackages.ghc-mod
        haskellPackages.intero

        # Scala
        scala
        sbt
        scalastyle

        # Idris
        # unstable.idris

        # Java
        jdk

        # JavaScript
        nodejs-8_x
        nodePackages.bower
        nodePackages.tern
        nodePackages.js-beautify
        nodePackages.eslint
        nodePackages.yarn

        # JSON
        jq
        jmespath

        # Ruby
        ruby
        bundler

        # Go
        go
        go2nix

        # Tools
        awscli
        ag
        ncat
        ipcalc
      ];
    };
  };
}
