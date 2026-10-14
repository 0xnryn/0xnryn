{ ... }:
{
  flake.nixosModules.configuration = { config, lib, pkgs, ... }:
  {
    nixpkgs.config.allowUnfree = true;
    
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      package = pkgs.nix;
    };

    system.stateVersion = "26.05"; 
    time.timeZone = "Asia/Kolkata"; i18n.defaultLocale = "en_US.UTF-8";

    security.polkit.enable = true;
    virtualisation.docker.enable = true;
    programs.nix-ld.enable = true;
  
    services = {
      printing.enable = true;
      libinput.enable = true;
      openssh.enable = true;  
      pipewire = {
        enable = true;
        pulse.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      vim nano wget git sops age home-manager nil nixd tpm2-tools sbctl tpm2-tss
    ];

  };
}
  
