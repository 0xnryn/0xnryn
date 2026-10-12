{ inputs, ... }:
{
  flake.nixosModules.hardware-0xnryn-laptop = 
  { config, lib, pkgs, modulesPath, ... }:
  
  {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];
  
    fileSystems."/" =
      { device = "/dev/disk/by-uuid/4c769794-ba96-43c6-9fc4-271dee45acf5";
        fsType = "ext4";
      };
  
    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/CDB1-D8D1";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
  
    swapDevices = [ ];
    
  };
}
