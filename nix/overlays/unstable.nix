self: _: {
  unstable = import <nixpkgs-unstable> {
    config = self.config;
  };

  nixpkgs-master = import <nixpkgs-master> {
    config = self.config;
  };
}
