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

  networking.hostName = "nixos-one";
}
