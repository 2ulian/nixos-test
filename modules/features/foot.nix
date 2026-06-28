{ config, pkgs, ... }: {

  flake.homeModules.foot = { config, pkgs, lib, ... }: {

    home.packages = [ pkgs.foot ];

    # p10k configuration:
    home.file = {
      ".config/foot/foot.ini" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/fellwin/nixos-config/dotfiles/foot/foot.ini";
      };
    };
  };
}
