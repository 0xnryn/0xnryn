{ inputs, ... }:
{
  configurations.home."sudha@0xnryn-laptop" = {
    system = "x86_64-linux";
    module = {
      imports = [
        inputs.self.homeModules.sudha
      ];
    };
  };
  configurations.nixos = {
    "0xnryn-laptop0" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-laptop"; in
      {
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" "dialout" ];
        };
        home-manager.users.sudha = {
          imports = [
            inputs.self.homeModules.sudha
          ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.lanzaboote.nixosModules.lanzaboote
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "15ach6" "secrets" "configuration" "networking" "gnome" "ollama"  
        ];
      };
    };
    "0xnryn-server0" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-server0"; in
      {
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}"
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" "dialout" ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "generic-server" "secrets" "configuration" "networking"
        ];
      };
    };
  };
}