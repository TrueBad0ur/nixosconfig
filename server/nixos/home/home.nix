{ config, pkgs, ... }:

{
  # For truebad0ur
  home-manager.users.truebad0ur = {
    home.stateVersion = "25.05";

    home.shellAliases = {
      tesst = "ls -lah";
    };

    programs.neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
      defaultEditor = true;
    };
  };

  # For root
  home-manager.users.root = {
    home.stateVersion = "25.05";

    programs.neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
      defaultEditor = true;
    };
  };
}
