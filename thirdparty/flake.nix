{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blackbox-tools-src = {
      url = "github:betaflight/blackbox-tools";
      flake = false;
    };
    minesddm-src = {
      url = "github:Davi-S/sddm-theme-minesddm";
      flake = false;
    };
    watermark-cli-src = {
      url = "github:chianti-ga/watermark-cli/v1.2.2";
      flake = false;
    };
  };

  outputs =
  {
    self,
    nixpkgs,
    blackbox-tools-src,
    minesddm-src,
    watermark-cli-src
  }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  rec {
    blackbox-tools = pkgs.callPackage ./blackbox-tools.nix { inherit blackbox-tools-src; };
    # pidscope = pkgs.callPackage ./pidscope.nix { inherit pidscope-src blackbox-tools; };
    minesddm = pkgs.callPackage ./minesddm.nix { inherit minesddm-src; };
    watermark-cli = pkgs.rustPlatform.buildRustPackage {
      pname = "watermark-cli";
      version = "1.2.2";
      src = watermark-cli-src;

      cargoLock.lockFile = ./watermark-cli.Cargo.lock;
      postPatch = ''
        ln -s ${./watermark-cli.Cargo.lock} Cargo.lock
      '';

      buildNoDefaultFeatures = true;
    };
  };
}
