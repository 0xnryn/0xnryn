{ ... }:
{
  flake.homeModules.sudha = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfree = true;
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
      platformio
      uv
      vscode
      brave
      android-tools
      minicom
      
      

      gnomeExtensions.clipboard-indicator
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gsconnect
      gnomeExtensions.caffeine
      gnomeExtensions.impatience
      gnomeExtensions.blur-my-shell
    ];
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
            pkgs.gnomeExtensions.appindicator.extensionUuid
            pkgs.gnomeExtensions.dash-to-dock.extensionUuid
            pkgs.gnomeExtensions.gsconnect.extensionUuid
            pkgs.gnomeExtensions.caffeine.extensionUuid
            pkgs.gnomeExtensions.impatience.extensionUuid
            pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          ];
        };
      };
    };
    programs.git = {
      enable = true;
      settings.user.name = "0xnryn";
      settings.user.email = "0xnryn@proton.me";
      
    };
  };
}