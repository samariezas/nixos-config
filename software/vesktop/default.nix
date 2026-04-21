{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./vesktop.patch
        ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    vesktop
  ];
}
