{ pkgs, lib, ... }:

let
  dir = ".config/polybar";
in
{
  home.file = {
    "polybar" = {
      source    = ./polybar/scripts;
      target    = dir;
      recursive = true;
    };
  };

  services = {
    polybar = {
      enable = true;
      script = "~/${dir}/launch.sh";
      package = pkgs.polybar.override {
        i3Support = true;
      };

      settings = {
        "settings" = {
          screenchange-reload = true;
          pseudo-transparency = false;
        };

        "bar/top"= {
          monitor          = "\${env:MONITOR:}";
          enable-ipc       = true;
          height           = 40;
          line-size        = 2;
          background       = "#0000";
          tray-position    = "right";
          tray-offset-x    = -15;
          tray-transparent = true;
          padding-right    = 3;
          module-margin    = 2;

          font-0 = "Siji:size=18;4";
          font-1 = "Font Awesome 5 Brands Regular:size=11;2";
          font-2 = "3270Narrow Nerd Font:size=15;2";
          font-3 = "Weather Icons:size=12;1";

          modules-left  = "i3";
          modules-right = "battery audio memory cpu temperature fs docker date";
        };

        "module/audio"       = import polybar/audio.nix;
        "module/battery"     = import polybar/battery.nix;
        "module/cpu"         = import polybar/cpu.nix;
        "module/date"        = import polybar/date.nix;
        "module/docker"      = import polybar/docker.nix;
        "module/fs"          = import polybar/filesystem.nix;
        "module/i3"          = import polybar/i3.nix;
        "module/memory"      = import polybar/memory.nix;
        "module/temperature" = import polybar/temperature.nix;
        "module/wifi"        = import polybar/wifi.nix;
      };
    };
  };
}
