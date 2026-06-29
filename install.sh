#!/bin/sh
#nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration.nix
nix-shell -p disko
sudo disko --mode disko --flake .#name
sudo nixos-install --no-channel-copy --no-root-password --flake .#name