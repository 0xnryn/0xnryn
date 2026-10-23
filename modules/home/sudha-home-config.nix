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
      texstudio
      miktex
    ];
    home.file.".config/BraveSoftware/Brave-Browser/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = 
    "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    programs.git = {
      enable = true;
      settings.user.name = "0xnryn";
      settings.user.email = "0xnryn@proton.me";
    };
  };
}