{ ... }:
{
  flake.nixosModules.kiwix = { config, lib, pkgs, ... }:
  {
    services.kiwix-serve = {
      enable = true;
      port = 1000;
      libraryPath = "/var/lib/kiwix";   # put your .zim files here
      openFirewall = true;
    };
  };
}