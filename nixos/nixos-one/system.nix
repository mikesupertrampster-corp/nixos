{ config, pkgs, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "ab0081a63efe2a40e5f3e5d6ac55eb61c2cba538";
     sha256 = "sha256:I9GhJFpQVcCqLEUQEyowhIB2bwCx13+3fc88t0a1LZs=";
   });
in
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    acpid.enable = true;
    xserver = {
      dpi = 160;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.extraSessionCommands = "xrandr"
      + "--output DP-2   --mode 2560x1440 --pos 0x0"
      + "--output HDMI-0 --mode 2560x1440 --pos 2560x0"
      + "--output DP-4   --mode 2560x1440 --pos 5120x0";
    };
  };

  i18n.defaultLocale = default.locale.i18n;
  networking.hostName = "nixos-one";
}
