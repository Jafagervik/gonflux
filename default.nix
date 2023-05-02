{ pkgs ? import <nixpkgs> { } }:
let
  gflx-unwrapped = pkgs.llvmPackages_11.stdenv.mkDerivation (rec {
    name = "gflx-unwrapped";
    src = ./.;
    dontConfigure = true;
    nativeBuildInputs = [ pkgs.git ];
    buildPhase = ''
      make debug SHELL=${pkgs.llvmPackages_11.stdenv.shell}
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp gfx $out/bin/gfx
      cp -r core $out/bin/core
    '';
  });
  path = builtins.map (path: path + "/bin") (with pkgs.llvmPackages_11; [
    bintools
    llvm
    clang
    lld
  ]);
in
pkgs.writeScriptBin "gfx" ''
  #!${pkgs.llvmPackages_11.stdenv.shell} 
  PATH="${(builtins.concatStringsSep ":" path)}" exec ${gflx-unwrapped}/bin/gfx $@
''

