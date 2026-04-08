{
  stdenv,
  pidscope-src,
  octaveFull,
  blackbox-tools,
  ...
}:
let
  octave = octaveFull.withPackages (ps: with ps; [
    signal
    statistics
    control
    image
  ]);
in
stdenv.mkDerivation {
  name = "pidscope";
  version = "v26.03.1";

  src = pidscope-src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
  	install -d $out/
    install -d $out/bin/
	cp PIDscope.m VERSION $out/
	cp -r src/ $out/
	cp ${blackbox-tools}/bin/blackbox_decode $out/
    printf "#!/usr/bin/env bash\nexec ${octave}/bin/octave --gui --persist --eval \"cd('$out'); PIDscope\"\n" > $out/bin/pidscope
	chmod +x $out/bin/pidscope
  '';
}
