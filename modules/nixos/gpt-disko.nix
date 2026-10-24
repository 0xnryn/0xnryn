{ ... }:
{
  flake.nixosModules.gpt-disko = { config, lib, pkgs, modulesPath, ... }:
  {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    options.disko.targetDevice = lib.mkOption {
      type = lib.types.str;
      description = "Target block device path for Disko partitioning";
    };

    config = {
      initrd.luks.devices."enc".crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-pcrs=7" ];

      disko.devices = {
        disk = {
          main = {
            type = "disk";
            device = config.disko.targetDevice;
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                luks = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "enc";
                    settings = {
                      allowDiscards = true;
                    };
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}