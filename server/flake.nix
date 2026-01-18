{
  description = "My NixOS flake conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/871b9fd269ff6246794583ce4ee1031e1da71895"; # nixos-25.11 13.12.2025
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mcp-simple-server = {
      url = "github:TrueBad0ur/mcp-simple-server/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, mcp-simple-server, ... }@inputs: {
    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({ config, pkgs, lib, ... }: {
	  _module.args.mcp-simple-server = mcp-simple-server;
	})

        ./nixos/configuration.nix
        inputs.home-manager.nixosModules.home-manager
      ];
    };
  };
}
