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
      settings = {
        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlMaster = "no";
          ControlPersist = "no";
        };
      };
    };
    home.stateVersion = config.system.stateVersion;
  };
}
