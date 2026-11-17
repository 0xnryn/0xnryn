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
        networking = { networkmanager.enable = true; inherit hostName;};
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        # microvm.host.enable = true;
        # microvm.vms."0xnryn-microvm0" = {
        #   flake = inputs.self;
        # };
        imports = NixosMods ++ [
          # extraMods
          # inputs.microvm.nixosModules.host
          # inputs.microvm.nixosModules.microvm

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
          inputs.microvm.nixosModules.microvm
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
        networking = { inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";

        fileSystems."/" = {
          device = "none";
          fsType = "tmpfs";
          options = [ "defaults" "size=256M" ]; # Capped at 256MB to protect your 512MB RAM limit
        };

        # MicroVM guest configuration
        microvm = {
          hypervisor = "qemu";
          mem = 512; # 2GB RAM (adjustable based on host constraints)
          vcpu = 1;
          shares = [
            {
              tag = "ro-store";
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
            }
            # {
            #   tag = "zim-archives";
            #   source = "/path/to/host/zim/files"; # Where your Kiwix files live on server0
            #   mountPoint = "/var/www/kiwix";      # Read-only path inside microvm0
            # }
          ];
          interfaces = [
            {
              type = "tap";
              id = "vm-micro0";
              mac = "02:00:00:00:01:01"; # Explicit MAC address required by microvm.nix
            }
          ];
        };

        imports = 
        NixosMods ++ [
          # extraMods
          inputs.microvm.nixosModules.microvm
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" 
          "server" 
          "networking" 
        ];
      };
    };
  };
}
