#!/bin/sh
#nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration.nix
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./modules/disko.nix --argstr disk /dev/sdb
#sudo mkdir -p /mnt/tmp
#sudo TMPDIR=/mnt/tmp nixos-install --root /mnt --flake .#nixos