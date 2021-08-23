let
  sources = import ../sources.nix;
in

self: super: {
  nur = import sources.NUR {
    pkgs = self;
  };
}
