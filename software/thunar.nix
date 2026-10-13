{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
  programs = {
    xfconf.enable = true;
    dconf.enable = true;
    thunar = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    xdg-utils
  ];
}
