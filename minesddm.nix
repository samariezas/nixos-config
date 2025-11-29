{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "sddm-theme-minesddm";
  version = "2.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "Davi-S";
    repo = "sddm-theme-minesddm";
    # rev = "v${version}";
    rev = "v2.1.0";
    hash = "sha256-WJV2pmWhLqQal+NOv4aMku3xv0NpGSN7gyhPXimRJEg=";
  };

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
