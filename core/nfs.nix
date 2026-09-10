{ pkgs, ... }:
{
  services.rpcbind.enable = true;
  boot.supportedFilesystems = [ "nfs" ];
  environment.systemPackages = [ pkgs.nfs-utils ];
}
