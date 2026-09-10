{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system.stateVersion = "25.05";

    boot.initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/ae98b94b-9bb0-426d-bf0f-15b10f7b48dc";
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
