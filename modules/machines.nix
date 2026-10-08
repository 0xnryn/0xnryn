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
        nixpkgs.hostPlatform = "x86_64-linux";
        time.timeZone = "Asia/Kolkata";
        i18n.defaultLocale = "en_US.UTF-8";
        networking = {
          networkmanager.enable = true;
          inherit hostName;
        };
        users.users.sudha = {
          isNormalUser = true;
          extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        };
        home-manager.users.sudha = {
          imports = [
            inputs.self.homeModules.sudha
          ];
        };
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.self.nixosModules."configuration-${hostName}"
          inputs.self.nixosModules."hardware-${hostName}"
        ];
      };
    };
  };
}