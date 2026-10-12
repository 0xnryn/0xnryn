{ ... }:
{
  flake.nixosModules."15ach6" = { config, lib, pkgs, modulesPath, ... }:
  {
    security.tpm2.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = { enable = true; pkiBundle = "/var/lib/sbctl"; };
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    hardware = {
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        open = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        dynamicBoost.enable = true;
        nvidiaSettings = true;        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
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
  
