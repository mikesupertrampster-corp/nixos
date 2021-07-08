{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #--------------------------------------------------------------------
    # interface
    #--------------------------------------------------------------------
    autorandr compton feh nitrogen networkmanagerapplet betterlockscreen
    dmenu polybar i3 i3blocks i3lock i3lock-color

    #--------------------------------------------------------------------
    # utilities
    #--------------------------------------------------------------------
    gnome3.gnome-screenshot gnome3.dconf gnome2.GConf alacritty tigervnc
    chromium imagemagick jq pmutils graphviz powertop unzip telnet lshw
    update-resolv-conf vim wget zip undervolt xclip firefox mpc_cli pciutils

    #--------------------------------------------------------------------
    # system
    #--------------------------------------------------------------------
    acpi alsaUtils arandr bc bind killall lm_sensors pulseaudioFull scrot
    pinentry wirelesstools xorg.xbacklight xorg.xdpyinfo hwinfo pavucontrol
    thunderbolt bolt usbutils gcc thefuck home-manager 

    #--------------------------------------------------------------------
    # work
    #--------------------------------------------------------------------
    aws awscli2 aws-iam-authenticator ssm-session-manager-plugin
    docker-credential-gcr google-cloud-sdk istioctl
    bash conftest docker docker-compose git tig trivy yq
    bazel go golangci-lint gotools gnumake gnupg openssl openjdk11 perl
    gh jetbrains.idea-ultimate slack
    fluxctl kind kubeval kubectx kubectl kubernetes-helm kustomize stern
    boundary consul-template packer terraform terragrunt vault
    (python39.withPackages(ps: with ps; [ boto3 google-api-python-client google-auth-httplib2 google-auth-oauthlib ]))

    #--------------------------------------------------------------------
    # Play
    #--------------------------------------------------------------------
    signal-desktop
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
