{ config, pkgs, ... }: {

  flake.homeModules.vesktop = { config, pkgs, lib, ... }: {

    home.packages = [ pkgs.vesktop ];

  };
}