{ pkgs, minesddm-src, ... }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "sddm-theme-minesddm";
  version = "2.1.0";
  src = minesddm-src;

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/minesddm
    cp -r minesddm/* $out/share/sddm/themes/minesddm/
  '';

  propagatedBuildInputs = with pkgs.kdePackages; [
    qtbase
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
    layer-shell-qt
  ];
}
