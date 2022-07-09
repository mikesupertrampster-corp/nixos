{ config, pkgs, lib, ... }:

let
  default = import (pkgs.fetchFromGitHub {
    owner  = "mikesupertrampster";
    repo   = "nixos";
    rev    = "033c3863e729a51749949ad3c688bc51f1a2b45b";
    sha256 = "sha256:HmC7ypvTNT1wQYYw6ggQAa30RqynpP3S0/STFUhEEbQ=";
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
    ./desktop/interface/alacrity.nix
    ./desktop/interface/i3.nix
    ./desktop/interface/polybar.nix
    ./desktop/interface/rofi.nix
  ];

  home = {
    homeDirectory   = default.user.home;
    username        = default.user.name;
    keyboard.layout = default.locale.keyboard.layout;
    stateVersion    = "22.11";

    packages = [
      pkgs.nodePackages.snyk
    ];

    sessionVariables = {
      GPG_TTY             = "$(tty)";
      KUBE_EDITOR         = "vi";
      MCFLY_FUZZY         = true;
      MCFLY_RESULTS       = 50;
      MCFLY_RESULTS_SORT  = "LAST_RUN";
      SSH_AUTH_SOCK       = "$(gpgconf --list-dirs agent-ssh-socket)";
      PASSWORD_STORE_DIR  = "${default.user.home}/.password-store";
      PASSWORD_STORE_KEY  = default.user.email;
      PASSWORD_STORE_GIT  = "git@github.com:mikesupertrampster/pass.git";
      TF_PLUGIN_CACHE_DIR = "${default.user.home}/Downloads/terraform-cache";
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
      goPath = "go";
    };

    mcfly = {
      enable = true;
      enableZshIntegration = false;
      keyScheme = "vim";
    };

    git = {
      enable                = true;
      userName              = default.user.user;
      userEmail             = default.user.email;
      signing.key           = default.user.sign;
      signing.signByDefault = true;
      aliases = {
        co = "checkout";
      };

      ignores = ["*.swp" "*.idea" "bin" "result"];

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

      matchBlocks = {
        "127.0.0.1" = {
          user = "core";
          certificateFile = [
            "~/.ssh/id_ecdsa-cert.pub"
            "~/.ssh/id_ecdsa"
          ];
          extraOptions = {
            StrictHostKeyChecking = "no";
          };
        };
      };
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
        plugins = [ "git" "sudo" "docker" "terraform" "helm" "aws" "vault" "kubectx" "kubectl" ];
        theme = "kolo";
      };

      shellAliases = {
        cat   = "bat";
        curl  = "curlie";
        diff  = "delta";
        dig   = "dog";
        df    = "duf";
        du    = "dust";
        find  = "fd";
        gcm   = "git checkout master";
        ls    = "exa";
        sound = "systemctl --user start edifier";
        t     = "terragrunt";
        ta    = "t apply";
        tfu   = "t force-unlock -force";
        ti    = "t import";
        taa   = "t apply --auto-approve";
        tp    = "t plan";
      };

      initExtra =  ''
        stty -ixon
        gpg-connect-agent /bye
        eval "$(mcfly init zsh)
        eval "$(zoxide init zsh)""
      '' + builtins.readFile ./desktop/interface/terminal/functions.sh;
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
      imageDirectory = "%h/.config/nixpkgs/desktop/backgrounds";
    };
  };

  systemd.user.services = {
    edifier = {
      Unit = {
        Description = "Automatically connect to edifier speakers";
        Requires    = "graphical-session.target bluetooth.target";
        After       = "graphical-session.target bluetooth.target";
      };
      Service = {
        Type      = "oneshot";
        ExecStart = "/run/current-system/sw/bin/bluetoothctl connect ${default.bluetooth.edifier}";
      };
      Install = {
        WantedBy = ["graphical-session.target" "bluetooth.target"];
      };
    };
  };
}
