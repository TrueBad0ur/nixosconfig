# NixOS

## Packages

### Clear before rebuild
> nix-collect-garbage

### Build local
> nix build --print-build-logs --rebuild

### Build from nixpkgs
> nix build nixpkgs#fastfetch

### Get the hash
> nix-prefetch-url https://ftp.gnu.org/gnu/hello/hello-2.12.2.tar.gz
> nix hash to-sri --type sha256 1aqq1379syjckf0wdn9vs6wfbapnj9zfikhiykf29k4jq9nrk6js
> nix-prefetch-url --type sha256 ftp://ftp.gnu.org/pub/gnu/hello/hello-2.12.2.tar.gz

### Placeholder for hash
> sha256 = lib.fakeHash;

### Install env
> nix-env -iA hello -f '<nixpkgs>'

### ENV IS DEPRECATED USE PROFILE
> nix profile list
> nix history

### List, diff, etc
> nix profile diff-closures
> nix profile list
> nix-env --rollback

### All dependencies
> nix-store -q --references $(which hello)
> nix-store -q --referrers $(which hello)
> nix-store -qR $(which hello) # nix-copy-closures / nix-store --export
> nix-store -q --tree $(which hello)
> nix-store -q --tree ~/.nix-profile

## System

### Channels
> sudo nix-channel --update
> sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
> sudo nix-channel --add https://channels.nixos.org/nixos-25.11 nixos
> sudo nixos-rebuild switch --flake /etc/nixos

# NeoVim

## Commands

