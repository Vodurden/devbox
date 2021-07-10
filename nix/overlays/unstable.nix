self: _: {
  nixpkgs-stable = import <nixpkgs-stable> {
    config = self.config;
  };

  nixpkgs-master = import <nixpkgs-master> {
    config = self.config;
  };
}
