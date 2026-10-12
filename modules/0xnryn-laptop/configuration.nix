{ inputs, ... }:
{
  flake.nixosModules.configuration-0xnryn-laptop = 
  # Edit this configuration file to define what should be installed on
  # your system. Help is available in the configuration.nix(5) man page, on
  # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
  { config, lib, pkgs, ... }:
  {
    nixpkgs.config.allowUnfree = true;
    
    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      package = pkgs.nix;
    };

    security = {
      pam.services.login.enableGnomeKeyring = true;
      polkit.enable = true;
    };
  
    services = {
      printing.enable = true;
      libinput.enable = true;
      openssh.enable = true;  
      pipewire = {
        enable = true;
        pulse.enable = true;
      };
    };

    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      vim wget git sops age brave home-manager zed-editor android-tools nil
    ];

    # gnome
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.gnome-keyring.enable = true;
    };
    environment.gnome.excludePackages = (with pkgs; [ epiphany gnome-music gnome-tour totem gnome-maps gnome-weather ]);
  };
}
  
