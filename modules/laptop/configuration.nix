{ inputs, ... }:
{
  flake.nixosModules.configuration-0xnryn-laptop = 
  # Edit this configuration file to define what should be installed on
  # your system. Help is available in the configuration.nix(5) man page, on
  # https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
  
  { config, lib, pkgs, ... }:
  
  {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.package = pkgs.nix;
    # imports =
    #   [ # Include the results of the hardware scan.
    #     ./hardware-configuration.nix
    #   ];
  
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  
    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;
  
    networking.hostName = "0xnryn-laptop"; # Define your hostname.
  
    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;
  
    # Set your time zone.
    time.timeZone = "Asia/Kolkata";
  
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };
  
    services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    security.polkit.enable = true;
  
    environment.gnome.excludePackages = (with pkgs; [
      epiphany # web browser
      gnome-music
      gnome-tour
      totem # video player
      gnome-maps
      gnome-weather
    ]);
  
    #15ach6 nvidia
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        open = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        dynamicBoost.enable = true;
        nvidiaSettings = true;        
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };
  
    # Enable CUPS to print documents.
    services.printing.enable = true;
  
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  
    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;
  
    # Define a user account. Don't forget to set a password with ‘passwd’
  
    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      brave
      zed-editor
    ];
  
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  
    # List services that you want to enable:
  
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    networking.firewall.enable = false;
  
    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;
  
    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
  
