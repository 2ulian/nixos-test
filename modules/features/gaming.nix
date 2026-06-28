{ config, pkgs, inputs, ... }:

{
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.steam.gamescopeSession.enable = true;
    hardware.steam-hardware.enable = true;
    programs.gamemode.enable = true;

    environment.systemPackages = [
      pkgs.ryubing
      pkgs.azahar
      pkgs.prismlauncher
      pkgs.protonup-qt
      pkgs.hydralauncher
    ];
  };
}
