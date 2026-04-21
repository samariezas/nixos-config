{ pkgs, config, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
}
