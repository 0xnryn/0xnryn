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
    
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ]; 
  
    # Select internationalisation properties.
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };
  
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    virtualisation.docker.enable = true;
    
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
      cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
  
    # services.libinput.enable = true;  
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      sops
      age
      brave
      home-manager
      zed-editor
      android-tools
    ];
  
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  
    # Open ports in the firewall.
    networking.firewall =
    let
      tcpPorts = [ 22 443 ];
      udpPorts = [ 443 9001 9002]; 
    in
    {
      enable = true;  
      allowedTCPPorts = tcpPorts;
      allowedUDPPorts = udpPorts;   
      # interfaces."ygg0" = {
      #   allowedTCPPorts = tcpPorts;
      #   allowedUDPPorts = udpPorts;
      # };
    };
    
#     services.yggdrasil = {
#       enable = true;
#       openMulticastPort = true;          # local Wi-Fi / LAN discovery
#       group = "wheel";                   # optional: let wheel users run yggdrasilctl
#     
#       settings = {
#         PrivateKeyPath = config.sops.secrets.yggdrasil.path;
#         IfName = "ygg0";
#         IfMTU  = 1280;   
#         Listen = [
#           "tls://[::]:443"
#           "quic://[::]:443"
#         ];
#         Peers = [
#           # india
#           "tls://ins.8px.sk:4321"
#           "quic://ins.8px.sk:4321"
#           # indonesia
#           "tls://supanadit.com:15021"
#           "quic://supanadit.com:15022"
#           # china
#           "tcp://ygg5.mk16.de:1337?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
#           "tls://ygg5.mk16.de:1338?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
#           "quic://ygg5.mk16.de:1339?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
#           "ws://ygg5.mk16.de:1340?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
#           # taiwan
#           "tcp://ygg-tw.lxak.net:80"
#           "tls://ygg-tw.lxak.net:443"
#           "tls://cowgl.tech:1337"
#         ];
# 
#         # Better control over local multicast discovery
#         MulticastInterfaces = [
#           {
#             Regex = ".*";  # Wi-Fi + Ethernet
#             Beacon = true;                     # announce yourself
#             Listen = true;                     # connect to others
#             Port = 9002;                          # random port
#             # Password = "local-mesh-secret";  # optional local password
#           }
#         ];
#     
#         # Hide build info from NodeInfo
#         NodeInfoPrivacy = true;
#         # -------------------------------------------------
#         # Optional advanced settings (uncomment to use)
#         # -------------------------------------------------
#     
#         # Only allow specific public keys to peer with you
#         # AllowedPublicKeys = [
#         #   "publickey1..."
#         #   "publickey2..."
#         # ];
#     
#         # Create a private group (closed network)
#         # GroupPassword = "your-very-long-shared-secret"
#     
#         # Custom NodeInfo (shown to other nodes)
#         # NodeInfo = {
#         #   name = "my-nixos-node";
#         #   location = "home";
#         # };
#       };
#     };
      
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
  
