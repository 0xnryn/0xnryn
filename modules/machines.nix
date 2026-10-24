{ inputs, ... }:
let
  NixosMods = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
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
      module = { modulesPath, pkgs, config, ... }:
      let hostName = "0xnryn-laptop0"; in
      {
        networking = { networkmanager.enable = true; inherit hostName;};
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        imports = NixosMods ++ [
          # extraMods

        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "networking" "workstation" "plasma" 
          "gpt-disko" "lanzaboote" 
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
