{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./modules/bundle.nix
      ./infra/bundle.nix
      ./home/bundle.nix
    ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Network
  networking = {
    hostName = "nixos-server";
    wireless.enable = false;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Locals
  time.timeZone = "Europe/Moscow";
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

  # UI
  services.xserver.enable = false;
  services.displayManager.sddm.enable = false;

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # Disable CUPS to print documents
  services.printing.enable = false;

  # Disable sound with pipewire
  security.rtkit.enable = true;
  services = {
    pulseaudio = {
      enable = false;
    };

    pipewire = {
      enable = false;
      alsa.enable = false;
      alsa.support32Bit = true;
      pulse.enable = false;
    };
  };

  # User
  users.users.truebad0ur = {
    isNormalUser = true;
    description = "truebad0ur";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCSppZZze4iUEfaw7IigP6Zxdw2nbDEzZEuFJYloE0YLztTkRrm+cLT0XtxLDgH8f1pD/JnHI3Oq/qNv0C+z/KjNUd9+ZYov59if0evx1s4foo4k3v7F1uAel0hbHA1jlsM1q41ogV08rWUlQAtsIwAp7OiWZIplz/GAC1c1fz9hcfSfTapv5sVxkoNZxca5mP8bEtqLlc2dBNOOthcT1pdnOqG+nCG2JeaBl7m286o3F+mb1cHWQpx45rQyDRZc3vt2zKgdsiSLJV/NZSiZM3DpAfQ62uFj4OXAI8HO5uIFT7ciqI5fH1Ad9t2YfauUQ4QsR+Ug30jE4SvcALpA6Ha4hNQob5SG4o+OUd2pKHhREGb/soAbKYac29+HyFvzFLoZBExLzbQszTJntNYyHgp0EplYv3WCVWSC0EXVVVsN8DWn+qPiRO5uJLSIjI0Nxb5Vrptsmtrc6vJVzBWhmtJHy2EkFxoUyf0/F+TSQ7VAa2LMSmxwkwl43Y2i3yGZxE="
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  # Disable defaults
  programs = {
    firefox.enable = false;
    nano.enable = false;
    zsh.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
