{ pkgs, lib, ... }:

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
        source = ./dotfiles/polybar.sh;
        target = ".config/polybar/launch.sh";
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
          userChrome = ''
            @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"); /* only needed once */

            /* full screen toolbars */
            #navigator-toolbox toolbar[moz-collapsed="true"]:not([collapsed="true"]) {
             visibility:visible!important;
            }
          '';
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
        mon
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