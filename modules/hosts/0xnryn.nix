{ inputs, ... }:
{
  configurations.nixos = {
    "0xnryn-laptop" = {
      system = "x86_64-linux";
      module = { ... }:
      let
        hostName = "0xnryn";
      in
      {
        networking = {
          networkmanager.enable = true;
          inherit hostName;
        };
        imports =
        [
          inputs.sops-nix.nixosModules.sops
          inputs.self.nixosModules.configuration-0xnryn-15ach6
          inputs.self.nixosModules.hardware-0xnryn-15ach6
          inputs.self.nixosModules.plasma-desktop
        ];
        users.users.sudha = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "adbusers" "tss" ];
          # openssh.authorizedKeys.keys = [
          # ];
        };
      };
    };
  };
}