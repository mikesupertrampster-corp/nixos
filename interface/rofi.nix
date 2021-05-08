{ pkgs, lib, ... }:

{
  programs = {
    rofi = {
      enable = true;

      extraConfig = {
        display-drun = "  ";
        drun-display-format = "{icon} {name}";
        font = "JetBrainsMono Nerd Font Medium 15";
        modi = "window,run,drun";
        show-icons = true;
      };

      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
        "*" = {
          polar-1 = mkLiteral "#2E3440";
          polar-2 = mkLiteral "#3B4252";
          polar-3 = mkLiteral "#434C5E";
          polar-4 = mkLiteral "#4C566A";

          snow-1 = mkLiteral "#D8DEE9";
          snow-2 = mkLiteral "#E5E9F0";
          snow-3 = mkLiteral "#ECEFF4";

          frost-1 = mkLiteral "#8FBCBB";
          frost-2 = mkLiteral "#88C0D0";
          frost-3 = mkLiteral "#81A1C1";
          frost-4 = mkLiteral "#5E81AC";

          aurora-1 = mkLiteral "#BF616A";
          aurora-2 = mkLiteral "#D08770";
          aurora-3 = mkLiteral "#EBCB8B";
          aurora-4 = mkLiteral "#A3BE8C";
          aurora-5 = mkLiteral "#B48EAD";

          background-color = mkLiteral "@polar-1";

          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "element" = {
          padding = 12;
          text-color = mkLiteral "@frost-3";
        };

        "element selected" = {
          text-color = mkLiteral "@aurora-3";
        };

        "entry" = {
          background-color = mkLiteral "@polar-2";
          padding = mkLiteral "12 0 12 3";
          text-color = mkLiteral "@frost-1";
        };

        "inputbar" = {
          children = map mkLiteral ["prompt" "entry"];
        };

        "listview" = {
          columns = 1;
          lines = 8;
        };

        "mainbox" = {
          children = map mkLiteral ["inputbar" "listview"];
        };

        "prompt" = {
          background-color = mkLiteral "@polar-2";
          enabled = true;
          font = "FontAwesome 12";
          padding = mkLiteral "12 0 0 12";
          text-color = mkLiteral "@frost-1";
        };

        "window" = {
          transparency = "real";
        };
      };
    };
  };
}