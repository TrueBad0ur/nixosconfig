# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    layout = "us";
    xkbVariant = "";
    libinput.touchpad.naturalScrolling = true;

    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu i3lock i3status
      ];
      configFile = "/etc/nixos/i3.conf";
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.truebad0ur = {
    isNormalUser = true;
    description = "truebad0ur";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  #fonts.fonts = with pkgs; [
  #  (nerdfonts.override { fonts = [ "MesloLGS NF Bold" "MesloLGS NF Bold Italic" "MesloLGS NF Italic" "MesloLGS NF Regular" ]; })
  #];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl
    neofetch zsh oh-my-zsh alacritty
    docker firefox git tdesktop htop tmux file feh xclip
    minikube kubernetes-helm jq kubectl
    libcap go gcc
  ]; # kube3d kubectl

  environment.shells = with pkgs; [ zsh ];
  environment.variables = {
    TERMINAL = "alacritty";
  };

  programs.ssh = {
    askPassword = "";
  };

  # zsh config
  programs.zsh = {
    promptInit = ''
      # git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
      # echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
      # cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf
      ## cp -r ./fonts $XDG_DATA_HOME/fonts
      # cp -r /etc/nixos/fonts /home/truebad0ur/.local/share/
      # chown -R truebad0ur:users /home/truebad0ur/.local/share/fonts/
      # autoload -U promptinit && promptinit
      neofetch
      # PROMPT='%n@%m%#>>>>'
    '';
    enable = true;
    shellAliases = {
      ls = "ls -lah --color";
      rebuild = "sudo nixos-rebuild switch";
      copy = "sudo cp -r /etc/nixos/* /home/truebad0ur/nixosconfig/curr_config && sudo chown -R truebad0ur:users /home/truebad0ur/nixosconfig/curr_config/";      
      k = "minikube kubectl";
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

  system.stateVersion = "23.05";
}
