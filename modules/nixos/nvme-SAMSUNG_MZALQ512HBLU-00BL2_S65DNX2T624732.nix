{ ... }:
{
  flake.nixosModules."nvme-SAMSUNG_MZALQ512HBLU-00BL2_S65DNX2T624732" = { config, lib, pkgs, modulesPath, ... }:
  {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HBLU-00BL2_S65DNX2T624732";
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
                  mountOptions = [ "umask=0077" 
                  ];
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
}
  
