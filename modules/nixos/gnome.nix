{ ... }:
{
  flake.nixosModules.gnome = { config, lib, pkgs, ... }:
  {
    # gnome
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    #   gnome.gnome-keyring.enable = true;
    };
    environment.gnome.excludePackages = (with pkgs; [ 
      epiphany gnome-music gnome-tour totem gnome-maps gnome-weather 
    ]);
  };
}
  
