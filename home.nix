{ pkgs, lib, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "ef4b5a484834554c6ac55a6941e5976f0cd5a487";
     sha256 = "sha256:10q3ylva0rrsdfbfj17na91d9zi42n7qisnrfcs7xxraw2mm15wk";
   });
in
{
  imports = [
    ./interface/wmgr.nix
    ./interface/polybar.nix
  ];

  home = {
    homeDirectory   = default.user.home;
    username        = default.user.name;
    keyboard.layout = default.locale.keyboard.layout;

    sessionVariables = {
      AWSSO_CMD          = "docker run --rm -it -v ~/.aws:/home/mettle/.aws --network host $(pass mettle/onelogin/image) --profile default -u $(whoami) --onelogin-password $(pass mettle/onelogin/password)";
      GPG_TTY            = "$(tty)";
      KUBE_EDITOR        = "vi";
      SSH_AUTH_SOCK      = "$(gpgconf --list-dirs agent-ssh-socket)";
      PASSWORD_STORE_DIR = "${default.user.home}/.password-store";
      PASSWORD_STORE_KEY = default.work.email;
      PASSWORD_STORE_GIT = default.work.passwordstore.git;
    };

    file = {
      "terminator" = {
        source = ./dotfiles/terminator.conf;
        target = ".config/terminator/config";
      };
    };
  };

  programs = {
    autorandr.enable      = true;
    chromium.enable       = true;
    feh.enable            = true;
    gpg.enable            = true;
    jq.enable             = true;
    home-manager.enable   = true;
    password-store.enable = true;

    go = {
      enable = true;
      goPath = ".go";
    };

    mcfly = {
      enable = true;
      enableZshIntegration = true;
      keyScheme = "vim";
    };

    alacritty = {
      enable = true;
      settings = {
        font.size = 11;
        shell.program = "/run/current-system/sw/bin/zsh";
      };
    };

    git = {
      enable                = true;
      userName              = default.work.name;
      userEmail             = default.work.email;
      signing.key           = default.work.gpg;
      signing.signByDefault = true;
      aliases = {
        co = "checkout";
      };
      ignores = ["*.swp" "idea"];
      extraConfig = {
        core = {
          editor = "vi";
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "current";
        };
        url."git@github.com:".insteadOf = "https://github.com";
      };
    };

    ssh = {
      enable = true;
      compression = false;
      forwardAgent = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      dotDir = ".config/zsh";
      history = {
        save = 100000000;
        size = 1000000000;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        path = ".config/zsh/.zsh_history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "terraform" "helm" "bazel" "aws" "vault" "thefuck" ];
        theme = "kolo";
      };
      shellAliases = {
        awsso = "eval $AWSSO_CMD";
        k     = "kubectl";
        t     = "terraform";
      };
      initExtra =  ''
        stty -ixon
        gpg-connect-agent /bye
      '' + builtins.readFile ./dotfiles/functions;
    };
  };

  services = {
    blueman-applet.enable         = true;
    keybase.enable                = true;
    network-manager-applet.enable = true;

    screen-locker = {
      enable = true;
      lockCmd = "i3lock";
      inactiveInterval = 60;
    };

    udiskie = {
      enable = true;
    };

    password-store-sync = {
      enable = false;
      frequency = "*:0/5";
    };
  };
}