{
  description = "My development environment";

  inputs.nixpkgs.url = path:./nixpkgs;
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware/master;
  inputs.home-manager = {
    url = github:nix-community/home-manager;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nur.url = github:nix-community/NUR;
  inputs.doom-emacs = {
    url = github:hlissner/doom-emacs;
    flake = false;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }: {
    nixosConfigurations.harpocrates = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config/machines/harpocrates/configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            (import ./nix/pkgs/overlay.nix)
            nur.overlay
          ];
        }
      ];
      specialArgs = { inherit inputs; };
    };

    homeConfigurations."jakew@jakew-cash.local" = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-darwin";
      homeDirectory = "/Users/jakew";
      username = "jakew";
      extraSpecialArgs = { inherit inputs; };
      stateVersion = "21.03";
      configuration = ./config/machines/work-cash/home.nix;
    };
  };
}
