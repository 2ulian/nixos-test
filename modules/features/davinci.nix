{ config, pkgs, ... }: {

  flake.nixosModules.davinci = { config, pkgs, lib, ... }: {

    environment.systemPackages = [ pkgs.davinci-resolve ];

    environment.variables = {
      RUSTICL_ENABLE = "radeonsi";
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa.opencl # Enables Rusticl (OpenCL) support
      ];
    };
  };
}
