{ ... }:
{
  flake.homeModules.sudha = { pkgs, lib, ... }: {
    home.username = "sudha";
    home.homeDirectory = "/home/sudha";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
      tree
      telegram-desktop
      libreoffice
      proton-pass
      proton-pass-cli
    ];
    programs.git = {
      enable = true;
      settings.user.name = "0xnryn";
      settings.user.email = "0xnryn@proton.me";
    };
  };
}