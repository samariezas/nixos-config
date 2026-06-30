{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../bluetooth.nix # TODO: fix
  ];

  config = {
    system.stateVersion = "26.05";

    boot.loader.grub.useOSProber = false;
    boot.initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/3b0c9eaf-e25d-4edb-9c0f-d7be0fb5a380";
        preLVM = true;
        allowDiscards = true;
      };
    };

    pevcas = {
      battery.enabled = true;
      bluetooth.enabled = true;
      shell.color = "red";
      gaming = {
        enable = true;
        steam = true;
        prism = true;
      };
    };
  };
}
