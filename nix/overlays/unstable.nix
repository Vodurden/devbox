self: _: {
  unstable = import <nixpkgs-unstable> {
    config = self.config;
  };
}
