{ ... }:
{
  flake.nixosModules.microvm = { config, lib, pkgs, inputs, ... }:
  {
    boot.kernelPackages = pkgs.linuxPackages_latest;
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
    programs.nix-ld.enable = true;
    users.users.sudha = { isNormalUser = true;
        initialPassword = "changeme";
        extraGroups = [ "wheel" "docker" "dialout" "tss" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAabj1XE8vzYb0MghyLQ3lN9H7fEVTSVoTI8NVs7S0UH sudha@0xnryn-laptop0"
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
        # "tailscale" = {
        #   mode = "0400";
        #   restartUnits = map (name: "tsnsrv-${name}.service") (
        #     builtins.attrNames config.services.tsnsrv.services
        #   );
        # };
        # "cloudflare" = {
        #   owner = "cloudflared";
        #   group = "cloudflared"; # Explicitly setting group prevents sops-nix auto-lookup error
        # };
      };
    };
  };
}