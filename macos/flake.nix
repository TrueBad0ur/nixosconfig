{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.kubectl
          #pkgs.python27
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Allow building via linux
      nix.linux-builder.enable = true;

      # Enable sudo via fingerprint
      security.pam.enableSudoTouchIdAuth = true;

      # Enable running intel binaries
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      system.defaults = {
        #dock.autohide = true;
        #dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        #finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "truebad0ur";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 5;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."truebad0urs-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."truebad0urs-MacBook-Air".pkgs;
  };
}
