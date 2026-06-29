{
  nixConfig = {
    extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
    extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    nixpkgs-brave.url = "github:NixOS/nixpkgs/4b6816a";

    impermanence.url = "github:nix-community/impermanence";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";
  };

  outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } (
    (inputs.import-tree ./modules ./hosts)
    {
      _module.args = { inherit (inputs) nix-cachyos-kernel; };
    });
}