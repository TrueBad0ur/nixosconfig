{
  description = "My NixOS flake conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/ff06bd3398fb1bea6c937039ece7e7c8aa396ebf"; # nixos-25.05 05.12.2025
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        inputs.home-manager.nixosModules.home-manager
      ];
    };
  };
}
