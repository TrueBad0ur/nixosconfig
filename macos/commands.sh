[ Links ]
https://nixcademy.com/posts/nix-on-macos/
https://nixcademy.com/downloads/cheatsheet.pdf

[ Installation ]
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

mkdir nix-darwin-config
cd nix-darwin-config
nix flake init -t nix-darwin

The nixpkgs.hostPlatform setting must be aarch64-darwin on Macs with Apple Silicon CPUs. On Intel-based Macs it can be left as x86_64-darwin.
The simple part at the bottom of the file in the darwinConfigurations."simple" attribute can be renamed to our hostname. This way we don’t need to provide the name explicitly when building or rebuilding the system configuration.

cp /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin

nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .

sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
sudo -i nix-channel --update nixpkgs

[ Useful ]
darwin-rebuild switch --flake .

- Update system -
nix flake update
darwin-rebuild switch --flake .

- Run per shell package -
NIXPKGS_ALLOW_INSECURE=1 nix-shell --impure -p python27

- Clear garbage from system -
nix-collect-garbage -d 

- Install / Remove package -
nix profile install nixpkgs\#python27
nix profile remove python27
