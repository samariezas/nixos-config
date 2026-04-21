{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "battery";
  version = "0.0.1";
  src = ./src;
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  buildPhase = ''
    gcc -Wall -Wextra -Werror -Os battery.c -o battery
  '';
  installPhase = ''
    cp battery $out
  '';
}
