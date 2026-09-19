{ inputs, ... }:
{
  imports = [
    inputs.self.flakeModules.default
  ];

  configurations.nixos = {
    "0xnryn-laptop" = {
      system = "x86_64-linux";
      module = { ... }:
      let
        hostName = "0xnryn-laptop";
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
          inputs.opinions.nixosModules.nryn-plasma
        ];
        sops.age.keyFile = "/etc/${hostName}-boot.txt";
        sops.secrets."ssh/ssh_host_ed25519_key" = {
          sopsFile = "${inputs.self}/secrets/${hostName}.yaml";
          format = "yaml";
          path = "/etc/ssh/ssh_host_ed25519_key"; # This is the symlink location
        };
        sops.secrets."git-access-tokens" = {
          sopsFile = "${inputs.self}/secrets/${hostName}.yaml";
          format = "yaml";
          mode = "0400";
        };
        # command to generate yggdrasil key
        # nix run nixpkgs#yggdrasil -- -useconffile <(yggdrasil -genconf -json) -exportkey
        sops.secrets."yggdrasil" = {
          sopsFile = "${inputs.self}/secrets/${hostName}.yaml";
          format = "yaml";
        };
        sops.secrets."sudha-ssh" = {
          sopsFile = "${inputs.self}/secrets/${hostName}.yaml";
          format = "yaml";
          path = "/home/sudha/.ssh/id_ed25519";
          mode = "0600";
          owner = "sudha";
        };
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