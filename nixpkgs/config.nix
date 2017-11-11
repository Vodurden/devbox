{
  allowUnfree = true;

  packageOverrides = pkgs_: with pkgs_; {
    scalastyle = callPackage ./scalastyle {};

    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        # Dotfile management
        rcm

        stdenv
        glibc.static

        # Editors
        emacs
        vim
        vimPlugins.vundle

        # Haskell
        ghc
        stack
        haskellPackages.apply-refact
        haskellPackages.hlint
        haskellPackages.stylish-haskell
        haskellPackages.hasktags
        haskellPackages.hoogle
        haskellPackages.ghc-mod
        haskellPackages.intero

        # Scala
        scala
        sbt
        scalafmt
        scalastyle

        # Idris
        haskellPackages.idris

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

        # Tools
        awscli
        ag
        ncat
        ipcalc
        # shush
      ];
    };
  };
}
