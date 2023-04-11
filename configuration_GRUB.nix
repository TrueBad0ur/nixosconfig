# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Obviously gonna use home manager later

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./neofetch-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # nmtui - network manager after installation

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
    layout = "us";
    xkbVariant = "";
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu i3status i3lock i3blocks
      ];
    };
  };

  # config for all users
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.truebad0ur = {
    isNormalUser = true;
    description = "truebad0ur";
    #shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget curl neofetch zsh oh-my-zsh alacritty docker firefox git tdesktop htop
  ];

  environment.shells = with pkgs; [ zsh ];
  environment.variables = {
    TERMINAL = "alacritty";
  };

  # zsh config
  programs.zsh = {
    promptInit = ''
      #cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf
      #cp /etc/nixos/neofetch.conf /home/truebad0ur/.config/neofetch/config.conf

      #autoload -U promptinit && promptinit
      #neofetch
    #  PROMPT='%n@%m%# '
    '';
    enable = true;
    shellAliases = {
      ls = "ls -lah --color";
      rebuild = "sudo nixos-rebuild switch";
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

  #programs.neofetch = {
  #  enable = true;
  #};
  #  config = lib.readFile ./neofetch.conf;
  #};


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
  system.stateVersion = "22.11"; # Did you read the comment?
  #system.activationScripts = {
  #  rfkillUnblockWlan = {
  #    text = ''
  #    rfkill unblock wlan
  #    '';
  #    deps = [];
  #  };
  #};
}
