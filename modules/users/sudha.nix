{ inputs, lib, config, ... }: {
  flake.homeConfigurations = {
    "sudha@0xnryn" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
          home.username = "sudha";
          home.homeDirectory = "/home/sudha";
          home.stateVersion = "26.05";
          programs.home-manager.enable = true;
          programs.git = {
            enable = true;
            settings.user = {
              name = "0xnryn";
              email = "0xnryn@proton.me";
            };
          };
        }
      ];
    };
  };
}