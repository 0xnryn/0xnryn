{ ... }:
{
  flake.nixosModules."generic-server" = { config, lib, pkgs, modulesPath, ... }:
  {
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    boot = {
      # enable grub
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    # temporary setup
    # todo: move to disko

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
    fileSystems."/" = { 
      device = "/dev/disk/by-uuid/4c769794-ba96-43c6-9fc4-271dee45acf5";
      fsType = "ext4";
    };
  
    fileSystems."/boot" = { 
      device = "/dev/disk/by-uuid/CDB1-D8D1";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    swapDevices = [ ];
  };
}
  
