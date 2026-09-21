{ ... }:
{
  flake.nixosModules.plasma-desktop = { pkgs, ... }:
  {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover    
    ];

    environment.systemPackages = with pkgs; [
      kdePackages.plasma-browser-integration
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kcolorchooser
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.sddm-kcm
      kdePackages.ktorrent
      kdePackages.isoimagewriter
      kdePackages.partitionmanager
      kdePackages.filelight
      kdiff3
      hardinfo2
      wayland-utils
      wl-clipboard
    ];
  };
}