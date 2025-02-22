git clone https://github.com/TrueBad0ur/nixosconfig.git

cd nixosconfig

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko.nix

nixos-generate-config --root /mnt

mv ./configuration.nix /mnt/etc/nixos/

nixos-install
