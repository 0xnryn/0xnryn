{ pkgs, ... }:
{
  home.username = "sudha";
  home.homeDirectory = "/home/sudha";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "0xnryn";
    userEmail = "0xnryn@proton.me";
  };
}