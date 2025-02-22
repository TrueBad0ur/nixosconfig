{ pkgs, ... }: {
  nixpkgs.config = {
    nixpkgs.config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    zsh
    neofetch
    git
    #  vim
    #  wget
  ];
}
