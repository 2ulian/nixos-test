{ self, inputs, config, ... }: {

  flake.nixosModules.disko = { pkgs, lib, ... }: {
    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persistent".neededForBoot = true; # sometimes needed too

    disko.devices.nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=25%" "mode=755" ];
      };
    };

    disko.devices = {
      disk = {
        sdb = {
          device = "/dev/sdb";
          type = "disk";

          content.type = "gpt";

          content.partitions.boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };

          content.partitions.esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          };
          content.luks = {
            size = "100%";
            label = "luks";
            content = {
              type = "luks";
              name = "cryptroot";
              extraOpenArgs = [
                "--allow-discards"
                "--perf-no_read_workqueue"
                "--perf-no_write_workqueue"
              ];
              # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
              settings = {
                crypttabExtraOpts = [ "fido2-device=auto" "token-timeout=10" ];
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];

                subvolumes = {

                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                  };

                  "/persistent" = {
                    mountOptions = [ "subvol=persistent" "noatime" ];
                    mountpoint = "/persistent";
                  };

                  "/nix" = {
                    mountOptions = [ "subvol=nix" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
}

