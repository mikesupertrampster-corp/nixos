{ config, pkgs, lib, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font.size          = 19;
        shell.program      = "/run/current-system/sw/bin/zsh";
        background_opacity = 0.9;
        cursor_style       = "Beam";

        colors = {
          primary = {
            background = "0x2e3440";
            foreground = "0xebcb8b";
          };
        };

        mouse_bindings = [
          {
            mouse  = "Middle";
            action = "PasteSelection";
          }
          {
            mouse  = "Right";
            action = "PasteSelection";
          }
          {
            mouse  = 5;
            action = "DecreaseFontSize";
          }
        ];
      };
    };
  };
}