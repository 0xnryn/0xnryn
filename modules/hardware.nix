{ inputs, lib, ... }:
{
  flake.nixosModules.hardware-0xnryn-15ach6 = { pkgs, config, modulesPath,... }: {
    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix") 
    ];
    
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/cd2712d1-7fe2-430d-86f8-b3fdec2a91ce";

    fileSystems = {
      "/" =
      { device = "/dev/mapper/enc";
        fsType = "ext4";
      };

      "/boot" =
      { device = "/dev/disk/by-uuid/D4C6-EAE1";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    };
}