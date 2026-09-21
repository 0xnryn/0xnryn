#modules/nixos.nix
{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          # ADD THIS: Allow defining the architecture directly
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
            description = "The architecture for this host.";
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
        };
      }
    );
  };
  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.configurations.nixos (
      name: { system, module }: inputs.nixpkgs.lib.nixosSystem { 
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ module ]; 
      }
    );
    checks =
      config.flake.nixosConfigurations
      |> lib.mapAttrsToList (
        name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system} = {
            "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
          };
        }
      )
      |> lib.mkMerge;
  };
}