{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./tuigreet.nix
      #./trackpoint.nix
      #./i3status.nix
      #./neofetch-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #### Networking ####

  networking = {
    #enableIPv6  = false;
    firewall.enable = false;
    hostName = "nixos-thinkpad";
    networkmanager.enable = true;
    wireless.enable = false;
    #wireless.iwd.enable = true;
    #networkmanager.wifi.backend = "iwd";
    extraHosts =
      ''
        127.0.0.1 test.local
      '';
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  #### Environment ####

  environment = {
    localBinInPath = true;
    shells = with pkgs; [ zsh ];
    variables = {
      TERMINAL = "alacritty";
    };

    etc = {
      "resolv.conf".text = "options edns0\nnameserver 8.8.8.8\nnameserver 1.1.1.1\n";
    };

    systemPackages = with pkgs; [
      # All tools
      nerdfonts
      emacs wget curl unzip dig vscode neofetch python3
      go zsh oh-my-zsh alacritty
      firefox
      docker git tdesktop htop tmux file feh xclip
      kubectl kubernetes-helm terraform jq
      iptables v2ray # v2raya - change to nekoray
      vlc # bluez bluetuith
      libcap go gcc ffmpeg-full
      nemo shutter xscreensaver
      rofi
      networkmanager-openconnect networkmanagerapplet
      wineWowPackages.stable

      musikcube
];
  };

  #### Programs ####
  programs = {
    nano.enable = false;
    ssh = {
      askPassword = "";
      startAgent = true;
    };
    zsh = {
      promptInit = ''
        cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf

        neofetch
        [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
      '';
      enable = true;
      shellInit = ''
        # Doesn't work, need to fix format
        delete-generations() {
          inputGenerationsArray=`printf "%s " $(seq $1 $2)`
          sudo nix-env --delete-generations "$inputGenerationsArray" --profile /nix/var/nix/profiles/system
        }

      '';
      shellAliases = {
        emacs = "emacs -nw";
        display = "xrandr --output HDMI-1-1 --left-of eDP-2 --auto";
        ls = "ls --color";
        rebuild = "sudo nixos-rebuild switch";
        customrebuild = "sudo nixos-rebuild -I nixpkgs=/home/truebad0ur/nixpkgs switch";
        copy = "sudo rm /etc/nixos/*\~ && sudo cp -r /etc/nixos/\* /home/truebad0ur/nixosconfig/thinkpadx200s_config && sudo chown -R truebad0ur:users /home/truebad0ur/nixosconfig/thinkpadx200s_config/";
        k = "kubectl";
        list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      };
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "dieter";
        plugins = [
          "git"
          "sudo"
        ];
      };
    };
  };

  #### Services ####
  services = {
    displayManager = {
      defaultSession = "none+i3";
    };

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };

    # i3 configuration
    xserver = {
      exportConfiguration = true;
      xkb = {
        options = "grp:caps_switch";
        layout = "us,ru";
      };
      #xkbOptions = "grp:toggle";

      enable = true;
      desktopManager.xterm.enable = false;

      displayManager = {
        session = [
          {
	    manage = "desktop";
            name = "default";
            start = ''exec i3 -c /etc/i3/config'';
          }
        ];
        lightdm = {
          enable = true;
          greeters = {
            gtk.enable = false;
	    tiny = {
	      enable = true;
              #label.user = "ユーザー名";
              #label.pass = "パスワード";
	    };
          };
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          #dmenu
	  i3lock i3status
        ];
        configFile = "/etc/nixos/i3.conf";
      };
    };

    #blueman.enable = true;
  };
  

  #### Time zone ####
  time.timeZone = "Europe/Moscow";

  # Console
  console = {
    keyMap = "us";
  };

  #### Localization ###

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8"; 
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  #### Font ####

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      dina-font
      proggyfonts
  
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;
  
      subpixel = {
        lcdfilter = "light";
      };
    };
  };

  #### Virtualisation ####
  virtualisation = {
    docker.enable = true;
  };

  #### systemd.services ####

  systemd.services = {
    xscreensaverstart = {
      enable = true;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 3;
      };
      path = with pkgs; [ xscreensaver sudo ];
      script = ''
        sudo -H -u truebad0ur xscreensaver --nosplash
      '';
      wantedBy = [ "multi-user.target" ];
    };
  };

  #### configs for users ####
  users = {
    defaultUserShell = pkgs.zsh;

    users.truebad0ur = {
      isNormalUser = true;
      description = "truebad0ur";
      extraGroups = [ "networkmanager" "wheel" "docker" "audio" ]; # "vboxusers" ];
      packages = with pkgs; [];
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
    librewolf = {
      ffmpegSupport = true;
      pipewireSupport = true;
    };
  };

  system.stateVersion = "24.05";
}
