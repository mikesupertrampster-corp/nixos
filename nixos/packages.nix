{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #--------------------------------------------------------------------
    # interface
    #--------------------------------------------------------------------
    autorandr betterlockscreen compton dmenu feh i3 i3blocks i3lock
    i3lock-color networkmanagerapplet nitrogen polybar

    #--------------------------------------------------------------------
    # utilities
    #--------------------------------------------------------------------
    alacritty bat chromium firefox gnome2.GConf mcfly fd exa zoxide ripgrep
    duf du-dust dogdns curlie httpie gnome3.gnome-screenshot graphviz
    imagemagick jq lshw mpc_cli pciutils pmutils powertop synergy inetutils
    tigervnc undervolt unzip update-resolv-conf vim wget xclip zip
    texlive.combined.scheme-full discord

    #--------------------------------------------------------------------
    # system
    #--------------------------------------------------------------------
    acpi alsaUtils arandr bc bind bolt gcc home-manager hwinfo killall
    lm_sensors pavucontrol pinentry pulseaudioFull scrot thefuck
    thunderbolt usbutils wirelesstools xorg.xbacklight xorg.xdpyinfo

    #--------------------------------------------------------------------
    # work
    #--------------------------------------------------------------------
    aws-iam-authenticator awscli2 bash bazel boundary conftest
    consul-template docker docker-compose docker-credential-gcr fluxctl
    gh git gnumake gnupg go golangci-lint google-cloud-sdk goreleaser
    gotools home-manager istioctl jetbrains.idea-community kind kubectl
    kubectx kubernetes-helm kubeval kustomize lastpass-cli nix-index
    nodePackages.snyk open-policy-agent openjdk11 openjfx11 opensc
    openssl packer pacman perl pkcs11helper slack vagrant lens
    ssm-session-manager-plugin stern terraform terragrunt tig trivy
    vault yq yubico-piv-tool yubikey-personalization kube-capacity
    jetbrains.goland go-ethereum teams yarn pulumi-bin minikube

    (python39.withPackages(ps: with ps; [
      boto3 google-api-python-client google-auth-httplib2
      google-auth-oauthlib yubikey-manager
    ]))

    #--------------------------------------------------------------------
    # Play
    #--------------------------------------------------------------------
    signal-desktop spotify
  ];

  environment.pathsToLink = [ "/share/zsh" ];
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };

    virtualisation = {
      docker.enable = true;
    };

    users.extraGroups.vboxusers.members = [ "mike" ];
}
