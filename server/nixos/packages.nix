{ pkgs, ... }: {
  nixpkgs.config = {
    nixpkgs.config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    zsh
    neofetch
    git
    dive
    podman-tui
    docker-compose
    tmux
    #  vim
    #  wget
  ];
}
