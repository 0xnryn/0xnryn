{ inputs, ... }:
{
  flake.nixosModules.sops = { config, lib, pkgs, ... }:
  {
    sops = {
      useTmpfs = true; # Relative path to your encrypted sops file
      defaultSopsFormat = "yaml";
      secrets = {
        "yggdrasil" = {
          mode = "0400";
          restartUnits = [ "yggdrasil.service" ];
        };
        # "cloudflare" = {
        #   owner = "cloudflared";
        #   group = "cloudflared"; # Explicitly setting group prevents sops-nix auto-lookup error
        # };
      };
    };
  };
}