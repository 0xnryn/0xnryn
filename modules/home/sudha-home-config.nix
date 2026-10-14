{ ... }:
{
  flake.homeModules.sudha = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.username = "sudha";
    home.homeDirectory = "/home/sudha";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
    xdg.enable = true;
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    home.packages = with pkgs; [
      tree
      telegram-desktop
      libreoffice
      platformio
      uv
      vscode
      brave
      android-tools
      minicom
    ];
    programs.git = {
      enable = true;
      settings.user.name = "0xnryn";
      settings.user.email = "0xnryn@proton.me";
    };
  };
}