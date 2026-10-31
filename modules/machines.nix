{ inputs, ... }:
let
  NixosMods = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
    inputs.nixos-wsl.nixosModules.default
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
        imports = NixosMods ++ [
          # extraMods
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "networking" "workstation" "plasma" 
          "gpt-disko" "lanzaboote" "ollama"
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
        sops.defaultSopsFile = ../secrets/${hostName}.yaml;
        sops.age.keyFile = "/etc/${hostName}.txt";
        imports = NixosMods ++ [
          # extraMods
        ] ++ map (moduleName: inputs.self.nixosModules.${moduleName}) [
          "substituters" "server" 
        ];
      };
    };
    configurations.nixOnDroid.phone = {
      system = "aarch64-linux";
      specialArgs = {
        username = "sudha";
      };
      module = { pkgs, config, username, ... }: {
        # Set state version according to nix-on-droid release
        system.stateVersion = "24.05";
        # System packages installed in Termux
        environment.packages = with pkgs; [
          vim
          git
          curl
          tmux
          htop
          ripgrep
          fd
        ];
        # Configure default shell or environment variables
        environment.sessionVariables = {
          EDITOR = "vim";
        };
        # Optional: Integrated Home-Manager configuration
        # home-manager = {
        #   backupFileExtension = "hm-backup";
        #   useGlobalPkgs = true;
        #   useUserPackages = true;
        #   config = {
        #     programs.bash.enable = true;
        #     programs.starship.enable = true;
        #   };
        # };
      };
    };
  };
}
