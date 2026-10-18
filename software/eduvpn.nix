{ pkgs, ... }:
{
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  environment.systemPackages = with pkgs; [ eduvpn-client ];
}
