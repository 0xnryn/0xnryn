{ ... }:
{
  flake.nixosModules.mango = { config, lib, pkgs, ... }:
  {
    programs.mango.enable = true;
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
  
