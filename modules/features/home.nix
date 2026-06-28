{ config, pkgs, inputs, self, ... }:

{
  flake.homeModules.fellwin = { pkgs, config, lib, ... }: {
    imports = [
      self.homeModules.zsh
      self.homeModules.foot
      self.homeModules.vesktop
      self.homeModules.obs
      self.homeModules.waybar
    ];
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "fellwin";
    home.homeDirectory = "/home/fellwin";

    services.syncthing.enable = true;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.11";
    home.packages = [
      pkgs.unzip
      pkgs.unrar
      pkgs.p7zip
      pkgs.vscode
      pkgs.haskellPackages.nixfmt
      pkgs.git
      pkgs.ncdu
      pkgs.qbittorrent
      pkgs.vlc
      pkgs.fastfetch
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.obsidian
      pkgs.tldr
      pkgs.btop
      pkgs.claude-code
      pkgs.keepassxc
      pkgs.telegram-desktop
      pkgs.anki
      pkgs.python3
      pkgs.retroarch-free
      pkgs.wine64
      pkgs.winetricks
      pkgs.lsfg-vk
      pkgs.lsfg-vk-ui
      pkgs.onlyoffice-desktopeditors
      pkgs.mullvad-browser
      pkgs.chromium
      (pkgs.writeShellScriptBin "pdftotext" ''
        for file in "''$@"; do
          if [ -f "''$file" ]; then
            name="''${file%.*}"
            echo "Converting ''$file to ''$nom.txt"
            ${pkgs.haskellPackages.pdftotext}/bin/pdftotext.hs text "''$file" > "''$name.txt"
          else
            echo "Erreur : ''$file is not a valid file."
          fi
        done
        echo "Done"
      '')
    ];

    home.file = {
      ".config/DankMaterialShell" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/fellwin/nixos-config/dotfiles/DankMaterialShell";
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
