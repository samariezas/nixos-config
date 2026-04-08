{
  stdenv,
  blackbox-tools-src,
  cairo,
  pkg-config,
  ...
}:
stdenv.mkDerivation {
  name = "blackbox-tools";
  version = "af5c31a";

  src = blackbox-tools-src;

  nativeBuildInputs = [
    cairo
    pkg-config
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp obj/blackbox_decode obj/blackbox_render $out/bin/
  '';
}
