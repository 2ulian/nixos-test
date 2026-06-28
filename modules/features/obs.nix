{ config, pkgs, ... }: {

  flake.homeModules.obs = { config, pkgs, lib, ... }: {

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-source-record
      ];
    };

  };
}
