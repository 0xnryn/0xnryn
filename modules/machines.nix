{ inputs, lib, ... }:
let
  NixosMods = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
    inputs.nixos-wsl.nixosModules.default
    inputs.tsnsrv.nixosModules.default
  ];
in
{
  configurations.home."sudha@0xnryn-laptop0" = {
    system = "x86_64-linux";
    module = {
      imports = [
        inputs.self.homeModules.sudha-gui
        inputs.self.homeModules.sudha-cli
      ];
    };
  };
  configurations.nixos = {
    "0xnryn-laptop0" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-laptop0"; in
      {
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";

       # 1. Create the bridge and assign the host IP
         systemd.network = {
          enable = true;
          wait-online.enable = false; # Don't block boot waiting for virtual interfaces

          netdevs."10-microbr".netdevConfig = {
            Kind = "bridge";
            Name = "microbr";
          };

          networks."10-microbr" = {
            matchConfig.Name = "microbr";
            address = [ "10.0.100.1/24" ];
            networkConfig = {
              ConfigureWithoutCarrier = true;
              DHCPServer = true; # Automatically gives VMs 10.0.100.x + sets gateway to 10.0.100.1
            };
            dhcpServerConfig = {
              EmitDNS = true;
              DNS = [ "9.9.9.9" "149.112.112.112" ];
            };
          };
          # 2. Declaratively plug ANY vm-* tap device into microbr the moment it appears
          networks."11-microvm-tap" = {
            matchConfig.Name = "vm-*";
            networkConfig.Bridge = "microbr";
          };
        };

        networking = {
          inherit hostName;
          networkmanager = {
            enable = true;
            unmanaged = [ "microbr" "interface-name:vm-*" ];
          };
          nat = {
            enable = true;
            internalInterfaces = [ "microbr" ];
          };
          firewall.trustedInterfaces = [ "microbr" ];
        };




        microvm.host.enable = true;
        microvm.vms."0xnryn-microvm0" = {
          flake = inputs.self;
        };
        imports = NixosMods ++ [
          # extraMods
          inputs.microvm.nixosModules.host
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "networking" "workstation" "plasma" 
          "lanzaboote" "ollama" "dualboot-0xnryn-laptop0" "15ach6-nvidia"
          "kiwix"
        ];
      };
    };
    "0xnryn-laptop0-wsl" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-laptop0-wsl"; in
      {
        networking = { inherit hostName;};
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        imports = NixosMods ++ [
          # extraMods
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "workstation-wsl" 
        ];
      };
    };
    "0xnryn-server0" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-server0"; in
      {
        networking = { inherit hostName;};
        _module.args.root_disk = "/dev/disk/by-id/ata-ST3500418AS_9VMVD6SC";
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        microvm.host.enable = true;
        microvm.vms."0xnryn-microvm0" = {
          flake = inputs.self;
        };
        imports = NixosMods ++ [
          # extraMods
          inputs.microvm.nixosModules.host
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "server" "mbr-disko" "networking" 
          # "kiwix"
        ];
      };
    };
    "0xnryn-microvm0" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-microvm0"; in
      {
        nix = {
          enable = true;
          # Optional: reuse the host's nixpkgs store path so `nix run nixpkgs#...`
          # does not download and unpack a ~200 MB tarball into your 1024M tmpfs
          registry.nixpkgs.flake = inputs.nixpkgs;
        };
        networking = {
          inherit hostName;
          useDHCP = true; # Just ask microbr for an IP on boot
        };

        fileSystems."/" = {
          device = "none";
          fsType = "tmpfs";
          options = [ "defaults" "size=1024M" "mode=0755" ]; # Capped at 256MB to protect your 512MB RAM limit
        };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/microvm/${hostName}.txt";
        fileSystems."/etc/microvm".neededForBoot = true;
        # MicroVM guest configuration
        microvm = {
          hypervisor = "qemu";
          vsock.cid = 3;
          mem = 1024; # 2GB RAM (adjustable based on host constraints)
          vcpu = 1;
          shares = [
            {
              tag = "ro-store";
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
            }
            {
              tag = "age-key-share";
              source = "/etc/microvm";
              mountPoint = "/etc/microvm";
              readOnly = true;
            }
          ];
          interfaces = [
            {
              type = "tap";
              id = "vm-microvm0";
              mac = "02:00:00:00:01:01";
            }
          ];
        };

        imports = 
        NixosMods ++ [
          # extraMods
          inputs.microvm.nixosModules.microvm
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" 
          "microvm" 
          "networking" 
        ];
      };
    };
  };
}
