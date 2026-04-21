{ config, ... }:
{
  pevcas.wm.users = [ "joris" ];
  home-manager.users.joris = { ... }:
  {
    programs.vim = {
      enable = true;
      settings = {
        relativenumber = true;
        expandtab = true;
      };
    };
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Joris Pevcevičius";
          email = "joris.pevcas@gmail.com";
        };
        credential.helper = "store";
      };
    };
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
    home.stateVersion = config.system.stateVersion;
  };
}
