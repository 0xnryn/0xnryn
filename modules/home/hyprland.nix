{ ... }:
{
  flake.homeModules.hyprland = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      kitty
      brightnessctl
      fuzzel
      playerctl
      wdisplays
    ];

    programs.caelestia = {
      enable = true;
      cli.enable = true; # Also adds caelestia-cli to path
    };
    
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";

        monitor = [
          ",preferred,auto,1.2"
        ];

        input = {
          touchpad = {
            natural_scrolling = true;
          };
        };

        decoration = {
          rounding = 6;
        };

        bind = [
          "$mainMod, R, exec, hyprctl reload"
          "$mainMod, Space, exec, fuzzel"
          "$mainMod, Return, exec, kitty"
          "$mainMod, Q, killactive"
          "$mainMod, M, exit"
          "$mainMod, F, togglefloating"
          "$mainMod SHIFT, F, fullscreen"

          # --- Laptop Function & Media Keys ---
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
          "$mainMod, P, exec, wdisplays"

          # --- Media Playback Controls ---
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioStop, exec, playerctl stop"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"

          # Workspaces 1-9
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
        ];

        # Mouse window dragging and resizing
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
