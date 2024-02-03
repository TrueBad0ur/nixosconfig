{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  #### Boot ####
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        #canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
	
        #theme = pkgs.stdenv.mkDerivation {
        #  pname = "distro-grub-themes";
        #  version = "3.1";
        #  src = pkgs.fetchFromGitHub {
        #    owner = "AdisonCavani";
        #    repo = "distro-grub-themes";
        #    rev = "v3.1";
        #    hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        #  };
        #  installPhase = "cp -r customize/nixos $out";
        #};

        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
        splashImage = ./grub.png;

        #extraEntriesBeforeNixOS = true;
        #extraEntries = ''
        #  menuentry "Reboot" {
        #    reboot
        #  }
        #  menuentry "Poweroff" {
        #    halt
        #  }
        #'';
      };
    };
  

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ac30a256-d5a9-40e4-adbe-97f62801cd91";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7822-BC1F";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d052c1d7-94a0-4fff-803b-ab42944d7bb1"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  #### Hardware ####
  # Sound
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraConfig = "load-module module-combine-sink";
      #systemWide = true;
    };

    bluetooth.enable = true;
  };
}
