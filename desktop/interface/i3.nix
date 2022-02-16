{ pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      bars = [];
      menu = "rofi -show drun";
      fonts = {
        names = [ "pango:monospace" ];
        size  = 15.0;
      };
      modifier = "Mod4";
      terminal = "alacritty";
      window = {
        titlebar = false;
        border = 0;
      };

      startup = [
        { command = "--no-startup-id compton"; }
        { command = "--no-startup-id ~/.config/polybar/launch.sh"; }
      ];

      keybindings = pkgs.lib.mkOptionDefault {
        "XF86AudioLowerVolume"  = "exec amixer sset 'Master' 5%- on";
        "XF86AudioRaiseVolume"  = "exec amixer sset 'Master' 5%+ on";
        "XF86AudioMute"         = "exec amixer sset 'Master' toggle";
        "XF86AudioMicMute"      = "exec amixer sset 'Capture' toggle";
        "XF86KbdBrightnessUp"   = "exec amixer set Capture 5%+";
        "XF86KbdBrightnessDown" = "exec amixer set Capture 5%-";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 20";
        "XF86MonBrightnessUp"   = "exec xbacklight -inc 20";
        "XF86Display"           = "exec xbackight -dec 20";
        "Print"                 = "exec scrot ~/scrot/%Y-%m-%d_%H-%M-%S.png";
      };
    };

    extraConfig = ''
      workspace 1 output DP-2
      workspace 2 output HDMI-0
      workspace 3 output DP-4
    '';
  };
}
