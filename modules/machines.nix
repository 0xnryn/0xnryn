{ inputs, ... }:
{
  configurations.home."sudha@0xnryn-laptop" = {
    system = "x86_64-linux";
    module = {
      imports = [
        inputs.mango.hmModules.mango
        inputs.hyprland.homeManagerModules.default
        inputs.dms.homeModules.dank-material-shell
        inputs.caelestia.homeManagerModules.default
        inputs.mangobar.homeManagerModules.default
        inputs.self.homeModules.sudha
        inputs.self.homeModules.niri-dms
      ];
    };
  };
  configurations.nixos = {
    "0xnryn-laptop" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-laptop"; in
      {
        nix.settings.trusted-users = [ "root" "sudha" ];
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" "dialout" ];
        };
        home-manager.users.sudha = {
          imports = [
            inputs.mango.hmModules.mango
            inputs.dms.homeModules.dank-material-shell
            inputs.caelestia.homeManagerModules.default
            inputs.hyprland.homeManagerModules.default
            inputs.mangobar.homeManagerModules.default
            inputs.self.homeModules.sudha
            inputs.self.homeModules.niri-dms
          ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.mango.nixosModules.mango
          inputs.hyprland.nixosModules.default
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "15ach6" "secrets" "configuration" "networking" "niri" "ollama"  
        ];
      };
    };
    "0xnryn-server" = {
      system = "x86_64-linux";
      module = { ... }:
      let hostName = "0xnryn-server"; in
      {
        networking = { networkmanager.enable = true; inherit hostName; };
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}";
        users.users.sudha = { isNormalUser = true;
          extraGroups = [ "wheel" "docker" ];
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
