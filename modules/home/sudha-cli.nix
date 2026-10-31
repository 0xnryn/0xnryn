{ ... }:
{
  flake.homeModules.sudha-cli = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.username = "sudha";
    home.homeDirectory = "/home/sudha";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
    xdg.enable = true;
    home.packages = with pkgs; [
      tree
      platformio
      uv
      android-tools
      minicom
      miktex
    ];
    programs.git = {
      enable = true;
      settings.user.name = "0xnryn";
      settings.user.email = "0xnryn@proton.me";
    };
  };
}