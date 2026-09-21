{ inputs, lib, ... }:
{
  flake.nixosModules.hardware-0xnryn-15ach6 = { pkgs, config, modulesPath,... }: {
    imports =[ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
    fileSystems."/" =
      { device = "/dev/mapper/enc";
        fsType = "ext4";
      };
    boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/0542be31-8427-4a0c-9814-5477785cf97c";
    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/504B-2FFA";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    swapDevices = [ ];
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}