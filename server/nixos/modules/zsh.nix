{
  programs.zsh = {
    promptInit = ''
      neofetch
      #[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
    '';
    enable = true;
    shellInit = '''';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      customrebuild = "sudo nixos-rebuild -I nixpkgs=/home/truebad0ur/nixpkgs switch";
      copy = "sudo cp -r /etc/nixos/\* /home/truebad0ur/nixosconfig/server/ && sudo cat /home/truebad0ur/README.md > /home/truebad0ur/nixosconfig/commands.txt && sudo chown -R truebad0ur:users /home/truebad0ur/nixosconfig/server/";
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
}
