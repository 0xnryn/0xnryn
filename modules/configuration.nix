#modules/configuration.nix
{ inputs, lib, ... }:
{
  flake.nixosModules.configuration-0xnryn-15ach6 = { pkgs, config, ... }:
  {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote 
    ];
    security.tpm2.enable = true;
    nixpkgs.config.allowUnfree = true;
    programs.nix-ld.enable = true;

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      };
      extraOptions = ''
        !include /run/secrets/git-access-tokens
      '';
    };

    boot = {
      initrd.systemd.enable = true;      
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      #to do: try cachyos kernel
      kernelPackages = pkgs.linuxPackages_latest;
      extraModulePackages = [ config.boot.kernelPackages.zenpower ];
      kernelModules = [ "kvm-amd" "zenpower" ];
      initrd.luks.devices."enc".crypttabExtraOpts = [ 
        "tpm2-device=auto"
        "tpm2-pcrs=7" 
      ];
  
      loader.systemd-boot.enable = lib.mkForce false;
      loader.efi.canTouchEfiVariables = true;
  
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
        autoGenerateKeys.enable = true; 
        autoEnrollKeys = {
          enable = true;
        };
      };
  
      kernelParams = [
        "amdgpu.gttsize=16384"
        # "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      ];
    };

    hardware = {
      bluetooth.enable = true;
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      cpu.amd.ryzen-smu.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        open = false;
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
    
    system.stateVersion = "26.05";
    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    environment.systemPackages = with pkgs; [
      age age-plugin-tpm android-tools
      bind brave
      curl
      droidcam 
      git gptfdisk
      home-manager htop helix
      jq
      mtr
      pciutils
      ryzenadj
      sbctl sops ssh-to-age
      tcpdump tree
      util-linux unzip
      vim
      wget
      zed-editor
    ];
    
    services = {
      printing.enable = true;
      openssh.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        wireplumber.enable = true;
      };
      xserver.videoDrivers = [ 
        "amdgpu" "nvidia" 
      ];
    };
  };
}
