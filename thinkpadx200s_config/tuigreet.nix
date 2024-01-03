{ pkgs, config, ... }:
{
  boot.kernelParams = [ "console=tty1" ];
  services.greetd = {
    enable = true;
    vt = config.services.xserver.tty;
    restart = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startx";
        user = "greeter";
      };
    };
  };
}
