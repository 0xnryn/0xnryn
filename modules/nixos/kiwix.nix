{ ... }:
{
  flake.nixosModules.kiwix = { config, lib, pkgs, ... }:
  {
    services.kiwix-serve = {
      enable = true;
      port = 2000;
      libraryPath = "/var/lib/kiwix/library.xml";
      openFirewall = true;
    };
    services.tsnsrv = {
      enable = true;
      services.kiwix = {
        authKeyPath = config.sops.secrets.tailscale.path;
        toURL = "http://127.0.0.1:2000";
        funnel = true;
      };
    };
  };
}