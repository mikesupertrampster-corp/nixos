{ config, pkgs, ... }:

{
  imports =
    [
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
       efi = {
         canTouchEfiVariables = true;
         efiSysMountPoint = "/boot/efi";
       };
    };
    initrd.secrets = { "/crypto_keyfile.bin" = null; };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = ["8.8.8.8" "4.4.4.4"];
    firewall.allowedTCPPortRanges = [ { from = 24800; to = 24800; } ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  time.timeZone = "Asia/Bangkok";

  hardware = {
    cpu.intel.updateMicrocode = true;
    facetimehd.enable = false;
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
    fonts = with pkgs; [font-awesome nerdfonts siji weather-icons material-icons ipafont];
  };

  services = {
    blueman.enable = true;
    xserver = {
      layout = "us";
      xkbVariant = "";

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

  users.users.mike = {
    isNormalUser = true;
    description = "Michael Liu";
    extraGroups = ["wheel" "docker" "network" "networkmanager" "audio" "plugdev" "disk"];
    packages = with pkgs; [];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  system.stateVersion = "22.11";
}
