{ config, pkgs, ... }: {

  flake.nixosModules.distrobox = { config, pkgs, lib, ... }: {

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = [
      pkgs.distrobox

      (pkgs.writeShellApplication {
        name = "kali";
        text = ''
          REMOVE="$HOME/.local/distrobox-bin:"
          PATH="''${PATH//$REMOVE/}"
          distrobox enter --root kali
        '';
      })

      (pkgs.writeShellApplication {
        name = "cachy";
        text = ''
          REMOVE="$HOME/.local/distrobox-bin:"
          PATH="''${PATH//$REMOVE/}"
          distrobox enter --root cachy
        '';
      })

      (pkgs.writeShellApplication {
        name = "pacman";
        text = ''
          /home/fellwin/.local/distrobox-bin/pacman "$@" && su - fellwin -c "/home/fellwin/nixos-config/modules/features/distrobox/export-distrobox-bin.sh &> /dev/null"
        '';
      })

      (pkgs.writeShellApplication {
        name = "yay";
        text = ''

          if [[ "$USER" == "root" ]]
          then
            bin=$(echo "$0" | rev | cut -d "/" -f 1 | rev)
            echo "Do not run $bin as root/sudo."
            exit 1
          else
            /home/fellwin/.local/distrobox-bin/yay "$@" && /home/fellwin/nixos-config/modules/features/distrobox/export-distrobox-bin.sh &> /dev/null
          fi
        '';
      })
    ];

    security.sudo.extraRules = [{
      users = [ "fellwin" ];
      commands = [{
        command = "/run/current-system/sw/bin/podman";
        options = [ "NOPASSWD" ];
      }];
    }];

    environment.extraInit = ''
      export PATH="$PATH:$HOME/.local/distrobox-bin"
    '';
  };
}
