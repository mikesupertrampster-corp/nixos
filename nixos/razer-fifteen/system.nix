{ config, pkgs, ... }:

{
  boot = {
    blacklistedKernelModules = ["dell_smbios" "iTCO_wdt"];
    cleanTmpDir = true;

    initrd = {
      kernelModules = ["nvme" "nvme_core"];
    };

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
  };

  services.acpid.enable = true;

  services = {
    xserver = {
      dpi = 160;
      videoDrivers = [ "nvidia" ];
      windowManager.i3.extraSessionCommands = "xrandr "
      + "--output HDMI-0 --mode 1920x1080 --pos 3840x0 --primary "
      + "--output eDP-1-1 --mode 3840x2160 --pos 0x0";
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

  networking.hostName = "nixos-fifteen";
}