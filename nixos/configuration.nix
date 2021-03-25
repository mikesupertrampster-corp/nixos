{ config, pkgs, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "f01b9484476f1d04d35e0bedeb8793c386158c0c";
     sha256 = "sha256:0m24dw1zbz6yrdiwmz6n2dmmyjbx2qj5v4xqdv4qvs71vz0cqm7z";
   });
in
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./system.nix
    (builtins.fetchGit {
      url = "https://github.com/rycee/home-manager.git";
      rev = "ddcd476603dfd3388b1dc8234fa9d550156a51f5";
    } + "/nixos")
  ];

  boot = {
    blacklistedKernelModules = [];
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      grub.configurationLimit = 2;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };

  console.font = default.locale.console.font;
  time.timeZone = default.locale.timeZone;
  
  hardware = {
    cpu.intel.updateMicrocode = true;
    facetimehd.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
    bluetooth.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      font-awesome-ttf
      powerline-fonts
      nerdfonts
      siji
    ];
  };

  services = {
    blueman.enable = true;
    xserver = {
      enable = true;
      windowManager = {
        i3.enable = true;
      };
      displayManager.defaultSession = "none+i3";
      libinput.enable = true;
    };

    printing = {
      enable = true;
      drivers = [pkgs.gutenprint];
    };
    timesyncd.enable = true;

    # Yubikey
    pcscd.enable = true;
    udev = {
      packages = [ pkgs.yubikey-personalization ];
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", ATTRS{idVendor}=="1050"
      '';
    };
  };

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.extraUsers = {
    "${default.user.name}" = {
      createHome = true;
      home = default.user.home;
      description = default.user.name;
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "network" "networkmanager" "audio" "plugdev" "disk"];
      uid = 1000;
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  system = {
    stateVersion = "20.09";
  };

  system.autoUpgrade = {
    enable = true;
    channel = https://nixos.org/channels/nixos-unstable;
  };
}
