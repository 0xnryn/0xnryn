{ ... }:
{
  flake.nixosModules.workstation-wsl = { config, lib, pkgs, inputs, ... }:
  {
    wsl.enable = true;
    wsl.defaultUser = "sudha";
    wsl.useWindowsDriver = true;
    environment.sessionVariables = {
        LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib" ];
    };
    system.stateVersion = "26.05"; 
    nix.settings.trusted-users = [ "root" "sudha" ];
    security = { polkit.enable = true; };
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "Asia/Kolkata"; 
    i18n.defaultLocale = "en_US.UTF-8";
    environment.systemPackages = with pkgs; [
        vim nano wget git sops age home-manager
    ];
    services = {
        printing.enable = true; 
        libinput.enable = true;
        openssh.enable = true; 
        pipewire = {
            enable = true; pulse.enable = true;
        };
    };
    hardware = {
        graphics = { enable = true; enable32Bit = true; };
    };
    programs.nix-ld.enable = true;
    users.users.sudha = { isNormalUser = true;
    extraGroups = [ "wheel" "docker" "dialout" ];
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