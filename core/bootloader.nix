{ pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine.enable = true;
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
