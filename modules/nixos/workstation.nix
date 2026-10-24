{ ... }:
{
  flake.nixosModules.workstation = { config, lib, pkgs, inputs, ... }:
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
        printing.enable = true; libinput.enable = true;
        openssh.enable = true;  power-profiles-daemon.enable = true;
        pipewire = {
            enable = true; pulse.enable = true;
        };
    };
    hardware = {
        bluetooth.enable = true;
        graphics = { enable = true; enable32Bit = true; };
    };
    programs.nix-ld.enable = true;
    users.users.sudha = { isNormalUser = true;
    extraGroups = [ "wheel" "docker" "dialout" "tss" ];
    };
    home-manager.users.sudha = {
        imports = [
            inputs.self.homeModules.sudha-cli
            inputs.self.homeModules.sudha-gui
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