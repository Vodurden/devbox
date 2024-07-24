{
  description = "My development environment";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.nixpkgs-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware/master;
  inputs.home-manager = {
    url = github:nix-community/home-manager;
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nur.url = github:nix-community/NUR;
  inputs.emacs-overlay.url = github:nix-community/emacs-overlay;
  inputs.declarative-cachix.url = github:jonascarpay/declarative-cachix;
  inputs.doom-emacs = {
    url = "github:hlissner/doom-emacs";
    flake = false;
  };
  inputs.replugged-nix-flake.url = "github:LunNova/replugged-nix-flake";

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, nur, emacs-overlay, declarative-cachix, replugged-nix-flake, ... }: {
    nixosConfigurations.harpocrates = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./config/machines/harpocrates/configuration.nix
        home-manager.nixosModules.home-manager 
        declarative-cachix.nixosModules.declarative-cachix {
          nixpkgs.overlays = [
            (import ./nix/pkgs/overlay.nix)
            (self: super: {
              unstable = import nixpkgs-unstable { system = self.system; config.allowUnfree = true; };
            })
            nur.overlay
            emacs-overlay.overlay
          ];
        }
      ];
      specialArgs = {
        inherit inputs;
      };
    };

    nixosConfigurations.oschon = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ./config/machines/oschon/configuration.nix
        home-manager.nixosModules.home-manager 
        declarative-cachix.nixosModules.declarative-cachix {
          nixpkgs.overlays = [
            (import ./nix/pkgs/overlay.nix)
            (self: super: {
              unstable = import nixpkgs-unstable { system = self.system; config.allowUnfree = true; };
            })
            nur.overlay
            emacs-overlay.overlay
          ];
        }
      ];
      specialArgs = {
        inherit inputs;
      };
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
