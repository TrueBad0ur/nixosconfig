{ config, pkgs, ... }:

{
  home-manager.users.truebad0ur = {
    home.stateVersion = "25.05";

    programs.neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
    };
  };
}
