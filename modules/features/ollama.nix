{ config, pkgs, ... }: {

  flake.nixosModules.ollama = { config, pkgs, lib, ... }: {

    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
    };

  };
}
