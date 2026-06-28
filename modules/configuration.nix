{ self, inputs, config, ... }: {

  flake.nixosModules.configuration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.hardware
      self.nixosModules.disko
      # self.nixosModules.niri
      # self.nixosModules.gaming
      # self.nixosModules.distrobox
      # self.nixosModules.davinci
      inputs.preservation.nixosModules.preservation
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.fellwin = config.flake.homeModules.fellwin;
      }
    ];

    flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      modules = [ config.flake.nixosModules.configuration ];
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.

    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.powersave = false;
    networking.nftables.enable = true;

    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_fastopen" = 3;
    };

    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    console = {
      useXkbConfig = true; # use xkb.options in tty.
    };

    virtualisation.waydroid.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb.layout = "fr";
    services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # services.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.fellwin = {
      isNormalUser = true;
      extraGroups =
        [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
      initialPassword = "password";
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
    # programs.firefox.enable = true;

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      inputs.nixpkgs-brave.legacyPackages.${pkgs.system}.brave-origin
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 55435 ];
    networking.firewall.allowedUDPPorts = [ 55435 ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.11"; # Did you read the comment?
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
    nix.settings.trusted-public-keys =
      [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        directories = [
          "/etc/nixos"
          "/var/log"
          #"/var/lib/bluetooth"
          "/var/lib/waydroid"
          "/var/lib/libvirt"
          "/etc/mullvad-vpn"
          #"/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
          #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
        ];

        files = [{
          file = "/etc/machine-id";
          inInitrd = true;
        }];

        # Preserve user files
        # users.yurii = {
        #   directories = [
        #     ".ssh"
        #     ".mozilla"
        #   ];
        #
        #   files = [
        #
        #   ];
        # };
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Virtualisation
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "fellwin" ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    networking.firewall.trustedInterfaces = [ "virbr0" "virbr1" "virbr2" ];

    services.mullvad-vpn.enable = true;

    nixpkgs.config.allowUnfree = true;
  };
}
