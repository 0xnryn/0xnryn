{ ... }:
{
  flake.nixosModules.networking = { config, lib, pkgs, ... }:
  {
    
    networking = {
      firewall = 
      let
        tcpPorts = [ 22 443 ];
        udpPorts = [ 443 9001 9002 ];
      in 
      {
        enable = true;
        allowedTCPPorts = tcpPorts;
        allowedUDPPorts = udpPorts;
        interfaces."ygg0" = {
          allowedTCPPorts = tcpPorts;
          allowedUDPPorts = udpPorts;
        };
      };
      networkmanager.dns = "none"; 
      nameservers = [
        "45.90.28.151"
        "45.90.30.151"                
        "2a07:a8c0::5a:61e3"
        "2a07:a8c1::5a:61e3"
      ];
    };


    services.yggdrasil = {
      enable = true;
      openMulticastPort = true;          # local Wi-Fi / LAN discovery
      group = "wheel";                   # optional: let wheel users run yggdrasilctl
    
      settings = {
        PrivateKeyPath = config.sops.secrets.yggdrasil.path;
        IfName = "ygg0";
        IfMTU  = 1280;   
        Listen = [
          "tls://[::]:443"
          "quic://[::]:443"
        ];
        Peers = [
          # indonesia
          "tls://supanadit.com:15021"
          "quic://supanadit.com:15022"
          # china
          "tcp://ygg5.mk16.de:1337?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
          "tls://ygg5.mk16.de:1338?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
          "quic://ygg5.mk16.de:1339?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
          "ws://ygg5.mk16.de:1340?key=0000009611ae5391dc0aceea9f3fa6a0dc1279f4306059339e84bfb8b74d2f9b"
          # taiwan
          "tcp://ygg-tw.lxak.net:80"
          "tls://ygg-tw.lxak.net:443"
          "tls://cowgl.tech:1337"
          # singapore
          "quic://asia.deinfra.org:15015"
          "tls://asia.deinfra.org:15015"
          "tls://yg-sin.magicum.net:23900"
          "tcp://yg-sin.magicum.net:23901"
        ];

        # Better control over local multicast discovery
        MulticastInterfaces = [
          {
            Regex = ".*";  # Wi-Fi + Ethernet
            Beacon = true;                     # announce yourself
            Listen = true;                     # connect to others
            Port = 9002;                          # random port
            # Password = "local-mesh-secret";  # optional local password
          }
        ];
    
        # Hide build info from NodeInfo
        NodeInfoPrivacy = true;
        # -------------------------------------------------
        # Optional advanced settings (uncomment to use)
        # -------------------------------------------------
    
        # Only allow specific public keys to peer with you
        # AllowedPublicKeys = [
        #   "publickey1..."
        #   "publickey2..."
        # ];
    
        # Create a private group (closed network)
        # GroupPassword = "your-very-long-shared-secret"
    
        # Custom NodeInfo (shown to other nodes)
        # NodeInfo = {
        #   name = "my-nixos-node";
        #   location = "home";
        # };
      };
    };
  };
}