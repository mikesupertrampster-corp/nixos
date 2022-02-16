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
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./packages.nix
    (builtins.fetchGit {
      url = "https://github.com/rycee/home-manager.git";
      rev = "91155a98ed126553deb8696b25556d782d2a5450";
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
    firewall.allowedTCPPortRanges = [ { from = 24800; to = 24800; } ];
  };

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
      nerdfonts
      siji
      weather-icons
      material-icons
      ipafont
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