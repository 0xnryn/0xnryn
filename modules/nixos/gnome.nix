{ ... }:
{
  flake.nixosModules.gnome = { config, lib, pkgs, ... }:
  {
    # gnome
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.gnome-keyring.enable = true;
    };
    security.pam.services = {
      gdm.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;   # already set by the module, but explicit is fine
    };
    environment.gnome.excludePackages = (with pkgs; [ 
      epiphany gnome-music gnome-tour totem gnome-maps gnome-weather 
    ]);
  };
}
  
