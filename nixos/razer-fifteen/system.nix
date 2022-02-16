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
    blacklistedKernelModules = ["dell_smbios" "iTCO_wdt"];
    cleanTmpDir = true;

    initrd = {
      kernelModules = ["nvme" "nvme_core"];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.configurationLimit = 2;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "pcie.aspm=force"
      "i915.enable_fbc=1"
      "i915.enable_gvt=1"
      "i915.enable_rc6=7"
      "i915.lvds_downclock=1"
      "i915.enable_guc_loading=1"
      "i915.enable_guc_submission=1"
      "i915.enable_psr=0"
    ];
  };

  hardware = {
    nvidia.prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId  = "PCI:0:2:0";
    };
    openrazer.enable = true;
  };

  services.acpid.enable = true;

  services = {
    xserver = {
      dpi = 160;
      videoDrivers = [ "nvidia" ];
    };
  };

  systemd.services = {
    undervolt = {
      description = "Undervolt";
      enable = true;
      serviceConfig = {
        ExecStart = "/run/current-system/sw/bin/undervolt --gpu -60 --core -160 --cache -160 --temp 40";
      };
      wantedBy = [ "multi-user.target" ];
    };
    turboff = {
      description = "Disable Turbo Boost on Intel CPU";
      enable = true;
      serviceConfig = {
        ExecStart = ''/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
        ExecStop  = ''/bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
        RemainAfterExit = "yes";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  i18n.defaultLocale = default.locale.i18n;
  networking.hostName = "nixos-fifteen";
}
