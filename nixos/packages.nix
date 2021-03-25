{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #--------------------------------------------------------------------
    # interface
    #--------------------------------------------------------------------
    compton dmenu feh i3 i3blocks i3lock i3lock-color
    networkmanagerapplet polybar nitrogen betterlockscreen autorandr

    #--------------------------------------------------------------------
    # utilities
    #--------------------------------------------------------------------
    gnome3.gnome-screenshot gnome3.gnome-terminal gnome3.dconf gnome2.GConf
    chromium imagemagick jq pmutils graphviz powertop unzip telnet lshw
    update-resolv-conf vim wget zip undervolt xclip firefox mpc_cli pciutils
    alacritty tigervnc

    #--------------------------------------------------------------------
    # system
    #--------------------------------------------------------------------
    acpi alsaUtils arandr bc bind killall lm_sensors pulseaudioFull scrot
    pinentry wirelesstools xorg.xbacklight xorg.xdpyinfo hwinfo pavucontrol
    thunderbolt bolt usbutils gcc thefuck home-manager

    #--------------------------------------------------------------------
    # work
    #--------------------------------------------------------------------
    awscli2 docker git slack gnupg terminator aws kubectx fluxctl perl
    kubectl aws-iam-authenticator openssl packer openjdk11 kustomize
    vault consul-template jetbrains.idea-ultimate pre-commit yq
    gnumake bazel go citrix_workspace google-cloud-sdk kubernetes-helm
    istioctl kind kubeval gitAndTools.pre-commit docker-compose gotools
    stern tig bash docker-credential-gcr ssm-session-manager-plugin
    trivy conftest hugo nodejs terraform-landscape terraform_0_14

    (python39.withPackages(ps: with ps; [ boto3 ]))

    #--------------------------------------------------------------------
    # Play
    #--------------------------------------------------------------------
    spotify signal-desktop
  ];

  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" "terraform" "helm" "bazel" "aws" "vault" "thefuck" ];
    };
  };

  virtualisation = {
    docker.enable = true;
  };
}
