with import <nixpkgs> {};

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
    #pkgs.boost
    #pkgs.cmake
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
