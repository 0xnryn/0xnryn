{ ... }:
{
  flake.nixosModules.systemd-boot = { config, lib, pkgs, modulesPath, ... }:
  {
    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          includeMicrosoftKeys = true;
          autoReboot = true;
        };
      };
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
      initrd = {
        availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "tpm_tis" "tpm_crb" ];
        systemd.enable = true;   
        luks.devices."enc" = {
          crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-pcrs=7" ];
        };
      };
      initrd.kernelModules = [ ];
      kernelModules = [ ];
      extraModulePackages = [ ];
    };
  };
}
  
