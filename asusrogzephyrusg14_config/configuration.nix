# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Obviously gonna use home manager later

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    extraHosts =
      ''
        127.0.0.1 test.local
      '';
    #nameservers = [ "104.248.36.8" ];
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  environment.etc = {
    "resolv.conf".text = "nameserver 104.248.36.8\n";
  };
  

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console.font = "cyr-sun16";
  console.keyMap = "us";
  #console.keyMap = "ruwin_cplk-UTF-8";
  #i18n.defaultLocale = "C.UTF-8";

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

  # docker config
  virtualisation.docker.enable = true;

 ## redo xscreensaver service from system to user, currently it somehow doesn't work
#  systemd.user.services.xscreensaverstart = {
#    description = "Start xscreensaver";
#    enable = true;
#    serviceConfig = {
#      Restart = "always";
#      RestartSec = "30";
#    };
#    path = with pkgs; [ xscreensaver ];
#    script = ''
#      xscreensaver --nosplash
#    '';
#    #script = ''
#    #  #xscreensaver --nosplash
#    #  whoami > /tmp/whoami
#    #'';
#    wantedBy = [ "default.target" ]; # starts after login
#  };

#  systemd.services.xscreensaverstart = {
#    description = "Start xscreensaver";
#    enable = true;
#    serviceConfig = {
#      Restart = "on-failure";
#      RestartSec = "3";
#    };
#    path = with pkgs; [ xscreensaver ];
#    script = ''
#      xscreensaver --nosplash
#      #whoami >> /tmp/whoami
#    '';
#    wantedBy = [ "multi-user.target" ]; # starts after login
#  };

  systemd.services.xscreensaverstart = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "3";
    };
    #environment = {
    #  User = "truebad0ur";
    #  Group = "truebad0ur";
    #};
    path = with pkgs; [ xscreensaver sudo ];
    script = ''
      sudo -H -u truebad0ur xscreensaver --nosplash
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

  #systemd.services.rogauracore = {
  #  enable = true;
  #  serviceConfig = {
  #    Restart = "on-failure";
  #    RestartSec = "3";
  #  };
  #  script = ''
  #    /home/truebad0ur/.nix-profile/bin/rogauracore brightness 3
  #  '';
  #  wantedBy = [ "multi-user.target" ]; # starts after login
  #};

  # autostart pulseaudio server

  #systemd.user.services.pulseaudioautostart = {
  #  description = "Start pulse audio server";
  #  serviceConfig.PassEnvironment = "DISPLAY";
  #  script = ''
  #    #pulseaudio --start
  #  '';
  #wantedBy = [ "multi-user.target" ]; # starts after login
  #};

  # Configurration for plasma
  #services.xserver = {
  #  layout = "us";
  #  xkbVariant = "";
  #  enable = true;
  #  displayManager.sddm.enable = true;
  #  desktopManager.plasma5 = {
  #    enable = true;
  #    excludePackages = with pkgs.plasma5Packages; [
  #      elisa gwenview okular oxygen khelpcenter plasma-browser-integration print-manager
  #    ];
  #  };
  #};

  # Configuration for i3
  services.xserver = {
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    # tty = 7;
    exportConfiguration = true;
    #xkbModel = "microsoft";
    layout = "us,ru";
    #xkbOptions = "ctrl:nocaps,lv3:ralt_switch_multikey,misc:typo,grp:rctrl_switch";
    xkbOptions = "grp:caps_switch";
    #xkbVariant = "workman,";
    
    enable = true;
    desktopManager.xterm.enable = false;
    
    #displayManager.startx.enable = true;
    displayManager.defaultSession = "none+i3";
    displayManager.lightdm = {
      enable = true;
      #theme = "sugar-dark";
    };

    #displayManager.lightdm.enable = false;
    #displayManager.gdm.enable = false;
    #displayManager.sessionCommands = [
    #  "xinput set-prop 11 'libinput Scroll Method Enabled' 0, 0, 1"
    #  "xinput set-prop 11 'libinput Button Scrolling Button' 2"
    #];
    windowManager.i3 = {
      enable = true;
      #extraPackages = with pkgs; [
      #  dmenu i3status i3lock i3blocks
      #];
      extraPackages = with pkgs; [
        dmenu i3lock i3status # xorg.xinit
      ];
      configFile = "/etc/nixos/i3.conf";
    };
  };

  # config for all users
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.truebad0ur = {
    isNormalUser = true;
    description = "truebad0ur";
    #shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget curl musikcube unzip dig vscode
    neofetch zsh oh-my-zsh alacritty vim
    docker firefox-devedition-unwrapped git tdesktop htop tmux file feh xclip
    minikube kubectl kubernetes-helm terraform wireguard-tools jq
    libcap go gcc ffmpeg-full
    cinnamon.nemo shutter xscreensaver #rogauracore
    #rogauracore
  ]; # kube3d kubectl

  environment.localBinInPath = true;

  #services.kubernetes = {
  #  roles = [ "master" "node" ];
  #};

  #services.k3s = {
  #  enable = true;
  #  serverAddr = "https://0.0.0.0:6443";
  #};
  environment.shells = with pkgs; [ zsh ];
  environment.variables = {
    TERMINAL = "alacritty";
  };

  # ssh client
  programs.ssh = {
    askPassword = "";
    startAgent = true;
  };

  # zsh config
  programs.zsh = {
    promptInit = ''
      #cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf
      cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf

      # autoload -U promptinit && promptinit
      neofetch
      [[ $commands[kubectl] ]] && source <(kubectl completion zsh)
      # PROMPT='%n@%m%#>>>>'
    '';
    enable = true;
    shellInit = ''
      delete-generations() {
        inputGenerationsArray=$(seq $1 $2)
        sudo nix-env --delete-generations $inputGenerationsArray --profile /nix/var/nix/profiles/system
      }

    '';
    shellAliases = {
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

  # screen brightness

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      
      #{ keys = [ 229 ]; events = [ "key" ]; command = "sudo /home/truebad0ur/.nix-profile/bin/rogauracore brightness 1"; }
      #{ keys = [ 230 ]; events = [ "key" ]; command = "sudo /home/truebad0ur/.nix-profile/bin/rogauracore brightness 3"; }
      #{ keys = [ 229 ]; events = [ "key" ]; command = "echo 1 > /tmp/229"; }
      #{ keys = [ 230 ]; events = [ "key" ]; command = "echo 1 > /tmp/230"; }
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  #system.activationScripts = {
  #  rfkillUnblockWlan = {
  #    text = ''
  #    rfkill unblock wlan
  #    '';
  #    deps = [];
  #  };
  #};
}
