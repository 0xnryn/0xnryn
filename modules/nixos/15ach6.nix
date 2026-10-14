{ ... }:
{
  flake.nixosModules."15ach6" = { config, lib, pkgs, modulesPath, ... }:
  {
    security.tpm2.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    services.power-profiles-daemon.enable = true;
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
      initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "tpm_tis" "tpm_crb" ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };

    hardware = {
      bluetooth.enable = true;
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
			mountOptions = [ "umask=0077" ];
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
			  mountOptions = [ "noatime" ];
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
  
