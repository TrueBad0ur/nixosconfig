{
  description = "My NixOS flake conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/36864ed72f234b9540da4cf7a0c49e351d30d3f1"; # nixos-24.11 22.02.2025
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
      ];
    };
  };
}
