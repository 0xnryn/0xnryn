{ ... }:
{
  flake.homeModules.mango = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      kitty
      brightnessctl
      wdisplays
      playerctl
      waybar
      fuzzel
      blueman
      networkmanagerapplet
      wireplumber
    ];
    services.mangobar = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = {
        layer = "top";
        height = 10;
        # buffer-scale = 1;

        modules-left = [ 
          
          # "window" 
        ];
        modules-center = [
          "workspaces" 
        ];
        modules-right = [
          "network"
          "pulseaudio"
          "backlight"
          "battery"
          "clock#time"
        ];
        workspaces = {
          hide-empty = false;
          "on-click" = "activate";
        };
        network = {
          format-wifi = "WIFI:{ssid}";
          format-disconnected = "OFFLINE";
          format-ethernet = "ETH:{ifname}";
          "on-click" = "kitty -e nmtui";
        };
        pulseaudio = {
          format = "VOL:{volume}%";
          format-muted = "muted";
          "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "on-scroll-up" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
        };
        backlight = {
          format = "BRT:{percent}%";
          "on-scroll-up" = "brightnessctl set +5%";
          "on-scroll-down" = "brightnessctl set 5%-";
        };
        battery = {
          format = "BAT:{percent}%";
        };
        "clock#time" = {
          format = "%H:%M %D";
        };
      };
    };
    
    wayland.windowManager.mango = {
      enable = true;
      autostart_sh = '''';
      settings = {
  	    border_radius = 6;
  	    trackpad_natural_scrolling = 1;
	      monitor_rule = [
          "name:.*,scale:1.2"
        ];
	      tag_rule = [
	        "id:*,layout_name:tile"
	      ];
        bind = [
          "SUPER,r,reload_config"
          "SUPER,space,spawn,fuzzel"
          "SUPER,Return,spawn,kitty"
          "SUPER,q,killclient"
 	        "SUPER,Tab,toggleoverview"
	        "SUPER, M, quit"
          "SUPER,f,togglefloating" # Added shortcut to detach/float windows
          "SUPER+SHIFT,f,togglefullscreen" 

          # --- Laptop Function & Media Keys ---
          "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
          "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
          "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
          "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle"
          "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 5%-"
          "NONE,XF86MonBrightnessUp,spawn,brightnessctl set +5%"
          "SUPER,p,spawn,wdisplays"
          # "NONE,XF86Calculator,spawn,qalculate-gtk"
          "NONE,XF86TouchpadToggle,toggle_trackpad_enable"
          # --- Media Playback Controls ---
          "NONE,XF86AudioPlay,spawn,playerctl play-pause"
          "NONE,XF86AudioStop,spawn,playerctl stop"
          "NONE,XF86AudioNext,spawn,playerctl next"
          "NONE,XF86AudioPrev,spawn,playerctl previous"
          # Workspaces 1-5
          "SUPER,1,view,1"
          "SUPER,2,view,2"
          "SUPER,3,view,3"
          "SUPER,4,view,4"
          "SUPER,5,view,5"
          "SUPER,6,view,6"
          "SUPER,7,view,7"
          "SUPER,8,view,8"
          "SUPER,9,view,9"
        ];
        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];
      };
    };
  };
}
