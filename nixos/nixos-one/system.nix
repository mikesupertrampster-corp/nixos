{ config, pkgs, ... }:

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
      windowManager.i3.extraSessionCommands = "xrandr --output DP-4 --mode 2560x1440 --pos 0x0 --output DP-2 --mode 2560x1440 --pos 2560x0 --output HDMI-0 --mode 2560x1440 --pos 5120x0";
    };
  };
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "nixos-one";
}
