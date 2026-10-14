{ ... }:
{
  flake.homeModules.gnome = { pkgs, lib, ... }: {
    programs.gnome-shell = {
      enable = true;
      extensions = [
        {
          package = pkgs.gnomeExtensions.blur-my-shell;
          id = "blur-my-shell@aunetx";
        }
        {
          package = pkgs.gnomeExtensions.gsconnect;
          id = "gsconnect@andyholmes.github.io";
        }
        {
          package = pkgs.gnomeExtensions.appindicator;
          id = "appindicator@rgcjonas.gmail.com";
        }
        {
          package = pkgs.gnomeExtensions.caffeine;
          id = "caffeine@patapon.info";
        }
        {
          package = pkgs.gnomeExtensions.dash-to-dock;
          id = "dash-to-dock@micxgx.gmail.com";
        }
        {
          package = pkgs.gnomeExtensions.impatience;
          id = "impatience@gfxmonk.net";
        }
      ];
    };
  };
}