{ config, pkgs, lib, ... }:

let
  default = import (pkgs.fetchFromGitHub {
     owner  = "mikesupertrampster";
     repo   = "nixos";
     rev    = "3c04fed20b6efc27f5f8986593033b27d3b97307";
     sha256 = "sha256:13ccqhh72j479x5c6xj6c579fin024wgra0nsxkpd7jhrafm0555";
  });
in
{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };

  imports = [
    ./interface/wmgr.nix
    ./interface/polybar.nix
    ./interface/monitor.nix
  ];

  home = {
    homeDirectory   = default.user.home;
    username        = default.user.name;
    keyboard.layout = default.locale.keyboard.layout;

    sessionVariables = {
      AWSSO_CMD          = "docker run --rm -it -v ~/.aws:/home/mettle/.aws --network host $(pass onelogin/image) --profile default -u $(whoami) --onelogin-password $(pass mettle/onelogin/password)";
      GPG_TTY            = "$(tty)";
      KUBE_EDITOR        = "vi";
      SSH_AUTH_SOCK      = "$(gpgconf --list-dirs agent-ssh-socket)";
      PASSWORD_STORE_DIR = "${default.user.home}/.password-store";
      PASSWORD_STORE_KEY = default.work.alt;
      PASSWORD_STORE_GIT = default.work.passwordstore.git;
    };

    file = {
      "terminator" = {
        source = ./dotfiles/terminator.conf;
        target = ".config/terminator/config";
      };
      "polybar" = {
        source    = ./dotfiles/polybar;
        target    = ".config/polybar";
        recursive = true;
      };
    };
  };

  programs = {
    autorandr.enable      = true;
    browserpass.enable    = true;
    feh.enable            = true;
    gpg.enable            = true;
    jq.enable             = true;
    home-manager.enable   = true;
    password-store.enable = true;

    chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock
        { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
        { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
        { id = "kaoholkoedbpjiangnchpfchhmageifp"; } # whatsapp
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # darkreader
        { id = "jpmkfafbacpgapdghgdpembnojdlgkdl"; } # aws
      ];
    };

    firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        browserpass
        darkreader
        https-everywhere
        lastpass-password-manager
        multi-account-containers
        ublock-origin
      ];

      profiles = {
        "${default.user.name}" = {
          name = "${default.user.name}";
        };
      };
    };

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

    rofi = {
      enable = true;
      extraConfig = {
        display-drun = "  ";
        drun-display-format = "{icon} {name}";
        font = "JetBrainsMono Nerd Font Medium 15";
        modi = "window,run,drun";
        show-icons = true;
      };
      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
        "*" = {
          polar-1 = mkLiteral "#2E3440";
          polar-2 = mkLiteral "#3B4252";
          polar-3 = mkLiteral "#434C5E";
          polar-4 = mkLiteral "#4C566A";
        
          snow-1 = mkLiteral "#D8DEE9";
          snow-2 = mkLiteral "#E5E9F0";
          snow-3 = mkLiteral "#ECEFF4";
        
          frost-1 = mkLiteral "#8FBCBB";
          frost-2 = mkLiteral "#88C0D0";
          frost-3 = mkLiteral "#81A1C1";
          frost-4 = mkLiteral "#5E81AC";
        
          aurora-1 = mkLiteral "#BF616A";
          aurora-2 = mkLiteral "#D08770";
          aurora-3 = mkLiteral "#EBCB8B";
          aurora-4 = mkLiteral "#A3BE8C";
          aurora-5 = mkLiteral "#B48EAD";
        
          background-color = mkLiteral "@polar-1";
          
          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };
        "element" = {
          padding = 12;
          text-color = mkLiteral "@frost-3";
        };
        "element selected" = {
          text-color = mkLiteral "@aurora-3";
        };
        "entry" = {
          background-color = mkLiteral "@polar-2";
          padding = mkLiteral "12 0 12 3";
          text-color = mkLiteral "@frost-1";
        };
        "inputbar" = {
          children = map mkLiteral ["prompt" "entry"];
        };
        "listview" = {
          columns = 1;
          lines = 8;
        };
        "mainbox" = {
          children = map mkLiteral ["inputbar" "listview"];
        };
        "prompt" = {
          background-color = mkLiteral "@polar-2";
          enabled = true;
          font = "FontAwesome 12";
          padding = mkLiteral "12 0 0 12";
          text-color = mkLiteral "@frost-1";
        };
        "window" = {
          transparency = "real";
        };
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

      ignores = ["*.swp" "*.idea" "bin"];

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

    random-background = {
      enable = true;
      imageDirectory = "%h/.config/nixpkgs/backgrounds";
    };
  };
}