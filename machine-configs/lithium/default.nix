{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../bluetooth.nix # TODO: fix
  ];

  config = {
    system.stateVersion = "25.05";

    boot.loader.grub.useOSProber = false;
    boot.initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/ae98b94b-9bb0-426d-bf0f-15b10f7b48dc";
        preLVM = true;
        allowDiscards = true;
      };
    };

    home-manager.users.joris = { ... }:
    {
      #TODO: fix
      # programs.ssh.matchBlocks.helium-zt = {
      #   hostname = config.pevcas.zerotier.helium-ip;
      #   user = "joris";
      #   port = 22;
      #
      #   forwardAgent = true;
      #   controlMaster = "auto";
      #   controlPersist = "10m";
      # };
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
