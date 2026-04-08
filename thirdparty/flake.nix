{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blackbox-tools-src = {
      url = "github:betaflight/blackbox-tools";
      flake = false;
    };
    pidscope-src = {
      url = "github:dzikus/PIDscope";
      flake = false;
    };
    minesddm-src = {
      url = "github:Davi-S/sddm-theme-minesddm";
      flake = false;
    };
  };

  outputs =
  {
    self,
    nixpkgs,
    blackbox-tools-src,
    pidscope-src,
    minesddm-src
  }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  rec {
    blackbox-tools = pkgs.callPackage ./blackbox-tools.nix { inherit blackbox-tools-src; };
    pidscope = pkgs.callPackage ./pidscope.nix { inherit pidscope-src blackbox-tools; };
    minesddm = pkgs.callPackage ./minesddm.nix { inherit minesddm-src; };
  };
}
