{ pkgs ? import
    (fetchTarball {
      url = "";
      sha256 = "";
    })
    { }
}:
pkgs.stdenv.mkDerivation rec {
  pname = "gonflux";
  version = "0.1.0";

  src = pkgs.fetchgit {
    url = "";
    rev = "";
    sha256 = "";
  };

  buildInputs = [
    pkgs.simgrid
    pkgs.boost
    pkgs.cmake
  ];

  configurePhase = ''
    mkdir build && cd ./build && cmake .
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv flux $out/bin
  '';
}
