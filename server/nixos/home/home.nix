{ config, pkgs, lib, ... }:

{
  # For truebad0ur
  home-manager.users.truebad0ur = {
    home.stateVersion = "25.05";
    home.shellAliases = {
      tesst = "ls -lah";
    };

    programs = {
      neovim = {
        enable = true;
        extraConfig = ''
          set number relativenumber
	  set clipboard=unnamedplus
        '';
        defaultEditor = true;
      };
      zsh = {
        enable = true;
        initContent = lib.mkBefore ''
          source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
          source ${./config/p10k.zsh}

          fastfetch
          export EDITOR="nvim";
        '';

        shellAliases = {
          rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
          customrebuild = "sudo nixos-rebuild -I nixpkgs=/home/truebad0ur/nixpkgs switch";
          copy = "sudo cp -r /etc/nixos/* /home/truebad0ur/nixosconfig/server/ && sudo chown -R truebad0ur:users /home/truebad0ur/nixosconfig/server/";
          list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
	  cdc = "cd /etc/nixos/nixos";
        };
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "powerlevel10k";
            src  = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
            file = "powerlevel10k.zsh-theme";
          }
        ];
      };
      tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
      };
    };
    home.file.".p10k.zsh".source = ./config/p10k.zsh;
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
