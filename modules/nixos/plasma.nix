{ ... }:
{
  flake.nixosModules.plasma = { config, lib, pkgs, ... }:
  {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager = {
        enable = true;
        settings = {
          # Configure custom wallpaper for the login greeter
          "Greeter][Wallpaper][org.kde.image][General" = {
            Image = "../../wallapers/mountains.jpg";
          };
        };
      };
    };

    systemd.services.plasmalogin.environment = {
      QT_SCALE_FACTOR = "1.2";
    };

    

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      kmail
      ktnef
      kontact
    ];

    environment.systemPackages = with pkgs; [
        # KDE Utilities
        kdePackages.kcalc # Calculator
        kdePackages.kcharselect # Character map
        kdePackages.kclock # Clock app
        kdePackages.kcolorchooser # Color picker
        kdePackages.kolourpaint # Simple paint program
        kdePackages.ksystemlog # System log viewer
        kdiff3 # File/directory comparison tool
        kdePackages.ktorrent
        kdePackages.kdeconnect-kde
        # Hardware/System Utilities (Optional)
        kdePackages.isoimagewriter # Write hybrid ISOs to USB
        kdePackages.partitionmanager # Disk and partition management
        hardinfo2 # System benchmarks and hardware info
        wayland-utils # Wayland diagnostic tools
        wl-clipboard # Wayland copy/paste support
        vlc # Media player
        kdePackages.kwallet
        kdePackages.kwallet-pam # Auto-unlocks wallet at login
        kdePackages.kwalletmanager # GUI to manage wallet keys
        libsecret
    ];

    # Enable KWallet integration
    security.pam.services.kdewallet.enable = true;

    # Ensure D-Bus and libsecret are available for apps like Proton
    services.dbus.enable = true;
  };
}
  
