{
  allowUnfree = true;

  packageOverrides = pkgs_: with pkgs_; {
    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        rcm                 # Dotfile management

        stdenv
        glibc.static
        gcc
        ruby
        bundler

        emacs
        vim

        nodejs-8_x
      ];
    };
  };
}
