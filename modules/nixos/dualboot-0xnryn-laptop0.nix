{ ... }:
{
  flake.nixosModules.dualboot-0xnryn-laptop0 = { config, lib, pkgs, modulesPath, ... }:
    {
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/mapper/enc";
        fsType = "ext4";
        };

    boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/dcd4f587-7146-40be-96d9-4898fcab8f39";

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/88F3-70D2";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
        };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
  
