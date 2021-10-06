{
  description = "My development environment";

  inputs.nixpkgs.url = path:./nixpkgs;
  inputs.nixos-hardware.url = github:NixOS/nixos-hardware/master;
  inputs.home-manager.url = github:nix-community/home-manager;
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
        { nixpkgs.overlays = [ nur.overlay ]; }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
