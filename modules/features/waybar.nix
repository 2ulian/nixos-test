{ config, pkgs, ... }: {

  flake.homeModules.waybar = { config, pkgs, lib, ... }: {

    home.packages = [ pkgs.waybar pkgs.tofi ];

  };
}