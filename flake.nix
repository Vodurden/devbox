{
  description = "My development environment";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware/master;
  inputs.home-manager = {
    url = github:nix-community/home-manager/release-22.11;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nur.url = github:nix-community/NUR;
  inputs.emacs-overlay.url = github:nix-community/emacs-overlay;
  inputs.declarative-cachix = {
    url = github:jonascarpay/declarative-cachix;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nix-doom-emacs = {
    url = "github:nix-community/nix-doom-emacs";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.doom-emacs = {
    url = "github:hlissner/doom-emacs";
    flake = false;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, emacs-overlay, declarative-cachix, ... }: {
    nixosConfigurations.harpocrates = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config/machines/harpocrates/configuration.nix
        home-manager.nixosModules.home-manager 
        declarative-cachix.nixosModules.declarative-cachix {
          nixpkgs.overlays = [
            (import ./nix/pkgs/overlay.nix)
            nur.overlay
            emacs-overlay.overlay
          ];
        }
      ];
      specialArgs = { inherit inputs; };
    };

    homeConfigurations."jakew" = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-darwin";
      homeDirectory = "/Users/jakew";
      username = "jakew";
      extraSpecialArgs = { inherit inputs; };
      stateVersion = "21.03";
      configuration = ./config/machines/work-cash/home.nix;
    };
  };
}
