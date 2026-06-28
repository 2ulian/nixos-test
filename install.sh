#!/bin/sh
#nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration.nix
sudo nix --show-trace --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#nixos --disk main /dev/sdb