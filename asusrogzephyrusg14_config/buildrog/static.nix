{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4fe8d07066f6ea82cda2b0c9ae7aee59b2d241b3.tar.gz";
    sha256 = "sha256:06jzngg5jm1f81sc4xfskvvgjy5bblz51xpl788mnps1wrkykfhp";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "rogauracore";
  version = "1.6.0";

  src = pkgs.fetchgit {
    url = "https://github.com/wroberts/rogauracore";
    rev = "a872431a59e47c1ab0b2a523e413723bdcd93a6e";
    sha256 = "sha256-SeG6B9ksWH4/UjLq5yPncVMTYjqMOxOh2R3N0q29fQ0=";
  };

  buildInputs = [
    pkgs.libusb1
    pkgs.autoreconfHook
  ];

  configurePhase = ''
    autoreconf -i
    ./configure
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv rogauracore $out/bin
  '';
}
