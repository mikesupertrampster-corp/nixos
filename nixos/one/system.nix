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
    };
  };

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "nixos-one";
}
