{ config, pkgs, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "be04fbda4f5a8f6149cc991b2f28cc95c8111b28";
     sha256 = "sha256:1v82jn606iw9rbw7d4ma29v8ighjvfv4wzazad765ha4akszzlw4";
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
