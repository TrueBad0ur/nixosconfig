{
  description = "My NixOS flake conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/871b9fd269ff6246794583ce4ee1031e1da71895"; # nixos-25.11 13.12.2025
    home-manager.url = "github:nix-community/home-manager/release-25.11";
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
