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
        glibc.static

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
        ghc
        stack
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
        idris

        # Java
        jdk

        # JavaScript
        nodejs-8_x
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
