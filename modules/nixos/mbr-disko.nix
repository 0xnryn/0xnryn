{ ... }:
{
  # Add mainDiskDevice to the incoming arguments, with a fallback default
  flake.nixosModules.mbr-disko = { config, pkgs, modulesPath, root_disk, ... }:
  {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
    
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = root_disk;
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02";
              };
              root = {
                size = "100%";
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
}