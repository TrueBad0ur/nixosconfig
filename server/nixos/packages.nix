{ pkgs, ... }: {
  nixpkgs.config = {
    nixpkgs.config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    zsh
    fastfetch
    git
    dive
    podman-tui
    docker-compose
    tmux
    htop
    #attic-server
    #attic-client
  ];
}
