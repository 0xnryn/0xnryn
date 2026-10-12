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
    "0xnryn-laptop" = {
      system = "x86_64-linux";
      module = { ... }:
      let
        hostName = "0xnryn-laptop";
      in
      {
        system.stateVersion = "26.05"; 
        nixpkgs.hostPlatform = "x86_64-linux";
        time.timeZone = "Asia/Kolkata";
        i18n.defaultLocale = "en_US.UTF-8";
        networking = {
          networkmanager.enable = true;
          inherit hostName;
        };
        sops = {
          age.keyFile = "/etc/${hostName}.txt";
          defaultSopsFile = ../secrets/${hostName}.yaml;
        };
        users.users.sudha = {
          isNormalUser = true;
          extraGroups = [ "wheel" "docker" "dialout" ]; # Enable ‘sudo’ for the user.
        };
        home-manager.users.sudha = {
          imports = [
            inputs.self.homeModules.sudha
          ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.self.nixosModules."configuration-${hostName}"
          inputs.self.nixosModules."hardware-${hostName}"
          inputs.self.nixosModules.hardware-15ach6
          inputs.self.nixosModules.networking
          inputs.self.nixosModules.sops
        ];
      };
    };
  };
}