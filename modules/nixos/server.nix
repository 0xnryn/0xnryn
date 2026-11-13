{ ... }:
{
  flake.nixosModules.server = { config, lib, pkgs, inputs, ... }:
  {
    
    system.stateVersion = "26.05"; 
    nix.settings.trusted-users = [ "root" "sudha" ];
    security = { polkit.enable = true; tpm2.enable = true; tpm2.pkcs11.enable = true; };
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Asia/Kolkata"; 
    i18n.defaultLocale = "en_US.UTF-8";
    environment.systemPackages = with pkgs; [
        vim nano wget git sops age home-manager tpm2-tools sbctl
    ];
    services = {
        libinput.enable = true;
        openssh = {
            enable = true;
            settings = {
                # Disables root login completely
                PermitRootLogin = "no"; 
                # Forces SSH keys instead of allowing passwords
                PasswordAuthentication = false; 
            };
        }; 
    };
    hardware = {
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    programs.nix-ld.enable = true;
    users.users.sudha = { isNormalUser = true;
        extraGroups = [ "wheel" "docker" "dialout" "tss" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAabj1XE8vzYb0MghyLQ3lN9H7fEVTSVoTI8NVs7S0UH sudha@0xnryn-laptop0"
        ];
    };
    home-manager.users.sudha = {
        imports = [
            inputs.self.homeModules.sudha-cli
        ];
    };
    sops = {
      useTmpfs = true; # Relative path to your encrypted sops file
      defaultSopsFormat = "yaml";
      secrets = {
        "yggdrasil" = {
          mode = "0400";
          restartUnits = [ "yggdrasil.service" ];
        };
        # "cloudflare" = {
        #   owner = "cloudflared";
        #   group = "cloudflared"; # Explicitly setting group prevents sops-nix auto-lookup error
        # };
      };
    };
  };
}