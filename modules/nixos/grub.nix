{ ... }:
{
  flake.nixosModules.grub = { config, lib, pkgs, modulesPath, ... }:
  {
    boot = {
      loader.grub.enable = true;
      loader.grub.device = root_disk;
      kernelPackages = pkgs.linuxPackages_latest;
      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "tpm_tis" "tpm_crb" ];
      };
      initrd.kernelModules = [ ];
      kernelModules = [ ];
      extraModulePackages = [ ];
      kernelModules = [ "kvm-amd" "kvm-intel" ];
    };
  };
}
  
