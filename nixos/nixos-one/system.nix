{ config, pkgs, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "033c3863e729a51749949ad3c688bc51f1a2b45b";
     sha256 = "sha256:HmC7ypvTNT1wQYYw6ggQAa30RqynpP3S0/STFUhEEbQ=";
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
