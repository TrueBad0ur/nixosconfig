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

  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #### Bootloader ####
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #### Networking ####

  networking = {
    #enableIPv6  = false;
    firewall.enable = false;
    hostName = "nixos";
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
      #(python3.withPackages(ps: with ps; [ pulsectl ]))
      #libpulseaudio
      # All tools
      emacs wget curl musikcube unzip dig vscode neofetch #python3
      go zsh oh-my-zsh alacritty
      docker firefox-devedition-unwrapped git tdesktop htop tmux file feh xclip
      minikube kubectl kubernetes-helm terraform wireguard-tools jq
      iptables v2ray v2raya
      filezilla
      vlc bluez bluetuith
      libcap go gcc ffmpeg-full
      cinnamon.nemo shutter xscreensaver
      rofi
      networkmanager-openconnect networkmanagerapplet
      # kube3d kubectl
      virtualbox libvirt vmware-workstation
      # All with wine
      wineWowPackages.stable

      # Custom builds
      (callPackage /home/truebad0ur/nixosconfig/asusrogzephyrusg14_config/buildrog/default.nix { })
    ];
  };

  #### Services ####
  services = {
    # i3 configuration
    xserver = {
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      exportConfiguration = true;
      layout = "us,ru";
      xkbOptions = "grp:caps_switch";
      
      enable = true;
      desktopManager.xterm.enable = false;
      
      displayManager = {
        defaultSession = "none+i3";
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
            tiny.enable = true;
          };
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu i3lock i3status
        ];
        configFile = "/etc/nixos/i3.conf";
      };
    };

    blueman.enable = true;

    #kubernetes = {
    #  roles = [ "master" "node" ];
    #};

    #k3s = {
    #  enable = true;
    #  serverAddr = "https://0.0.0.0:6443";
    #};

    
    # screen brightness
    
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      ];
    };
  };

  programs = {
    light.enable = true;

    # rofi config
    # todo in home manager
    #programs.rofi = {
    #  enable = true;
    #  theme = "/home/truebad0ur/nixosconfig/asusrogzephyrusg14_config/rofi/DarkBlue.rasi";
    #};

    ssh = {
      askPassword = "";
      startAgent = true;
    };

    nano = {
      enable = false;
    };

    zsh = {
      promptInit = ''
        #cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf
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
        rog = "sudo rogauracore brightness 3";
        ls = "ls --color";
        rebuild = "sudo nixos-rebuild switch";
        customrebuild = "sudo nixos-rebuild -I nixpkgs=/home/truebad0ur/nixpkgs switch";
        copy = "sudo cp -r /etc/nixos/\* /home/truebad0ur/nixosconfig/asusrogzephyrusg14_config && sudo chown -R truebad0ur:users /home/truebad0ur/nixosconfig/asusrogzephyrusg14_config/";
        k = "kubectl";
        startminikube = "minikube start --nodes 1 -p mycluster";
        deleteminikube = "minikube delete --profile mycluster";
        list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        vpnstart = "wg-quick up ~/.config/andrey.conf";
        vpnstop = "wg-quick down ~/.config/andrey.conf";
        #mattermost = "appimage-run /home/truebad0ur/binaries/mattermost-desktop-5.6.0-linux-x86_64.AppImage";
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
  

  #### Time zone ####
  time.timeZone = "Europe/Moscow";

  # Console
  console = {
    keyMap = "us";
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #### Virtualisation ####
  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
    vmware.host.enable = true;
    vmware.guest.enable = true;
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

    rogauracore = {
      # in systemd it fails, because rog return other value than zero
      enable = true;
      startLimitIntervalSec = 5;
      startLimitBurst = 3;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
      };
      script = ''
        /run/current-system/sw/bin/rogauracore brightness 3
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
      extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
      packages = with pkgs; [];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
