{ ... }:
{
  flake.nixosModules.niri = { config, lib, pkgs, ... }:
  {
    programs.niri.enable = true;
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.tuigreet}/bin/tuigreet";
                user = "greeter";
            };
        };
    };
  };
}
  
