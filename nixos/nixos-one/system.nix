{ config, pkgs, ... }:

{
  services = {
    acpid.enable = true;
    xserver = {
      dpi = 160;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.extraSessionCommands = "xrandr "
      + "--output HDMI-0 --mode 1920x1080 --pos 3840x0 --primary";
    };
  };

  networking.hostName = "nixos-one";
}
