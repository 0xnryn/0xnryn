{ ... }:
{
  flake.nixosModules.tailscale = { config, lib, pkgs, inputs, ... }:
  {
    services.tailscale.enable = true;
    services.tailscale.authKeyFile = config.sops.secrets.tailscale.path;
  };
}