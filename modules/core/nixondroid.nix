# Provides an option for declaring Nix-on-Droid configurations.
# These configurations end up as flake outputs under `#nixOnDroidConfigurations."<name>"`.
# A check for the activation package of each configuration also ends
# under `#checks.<system>."configurations:nixOnDroid:<name>"`.
{ lib, config, inputs, ... }:
{
  options.configurations.nixOnDroid = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "aarch64-linux";
            description = "Target system architecture (e.g., aarch64-linux)";
          };

          specialArgs = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = "Extra arguments passed to nixOnDroidConfiguration";
          };

          module = lib.mkOption {
            type = lib.types.deferredModule;
            description = "Nix-on-Droid module";
          };
        };
      }
    );
  };

  config.flake = {
    nixOnDroidConfigurations = lib.mapAttrs (
      name: cfg:
      inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs {
          system = cfg.system;
        };
        extraSpecialArgs = { inherit inputs; } // cfg.specialArgs;
        modules = [
          cfg.module
        ];
      }
    ) config.configurations.nixOnDroid;

    checks = lib.mkMerge (
      lib.mapAttrsToList (
        name: nixOnDroid: {
          ${nixOnDroid.pkgs.stdenv.hostPlatform.system} = {
            "configurations:nixOnDroid:${name}" = nixOnDroid.activationPackage;
          };
        }
      ) config.flake.nixOnDroidConfigurations
    );
  };
}