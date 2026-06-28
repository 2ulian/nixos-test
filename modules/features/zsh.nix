{ config, pkgs, ... }: {

  flake.homeModules.zsh = { config, pkgs, lib, ... }: {

    home.packages = [ pkgs.lsd ];

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      history = {
        size = 10000;
        save = 10000;
        share = true;
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        ignoreSpace = true;
      };

      plugins = [{
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }];

      # .zshrc
      initContent = ''
        # pywal
        #(cat ~/.cache/wal/sequences &)

        # emacs mode
        bindkey -e

        # Configuration of powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # Configuration of historySubstringSearch
        zmodload zsh/terminfo
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down
        #bindkey '^[[A' history-substring-search-up
        #bindkey '^[OA' history-substring-search-up
        #bindkey '^[[B' history-substring-search-down
        #bindkey '^[OB' history-substring-search-down

        # Set terminal title to current directory
        precmd() {
          print -Pn "\e]0;%n@%m:%~\a"
        }
      '';

      shellAliases = {
        ls = "lsd";
        ll = "lsd -l";
        update = "sudo nixos-rebuild switch --flake ~/nixos-config/ --impure --accept-flake-config";
        search = "nix search nixpkgs";
        clean = "sudo nix-collect-garbage -d";
        dockerclean = "sudo docker system prune -a";
        journalclean = "sudo journalctl --vacuum-time=7d";
        vpniut =
          "sudo ${pkgs.openfortivpn}/bin/openfortivpn u-vpn-plus.unilim.fr --saml-login";
        cachycreate = "distrobox create --root --name cachy --init --image cachyos/cachyos:latest";
        kalicreate = "distrobox create --root --name kali --init --image kalilinux/kali-rolling:latest";
      };
    };

    # p10k configuration:
    home.file = {
      ".p10k.zsh" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/fellwin/nixos-config/dotfiles/.p10k.zsh";
      };
    };

  };
}
