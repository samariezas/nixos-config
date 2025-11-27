{ config, pkgs, lib, ... }:
let
  username = "joris";
  temporary-file = "/var/tmp/${username}_git_repos";
in {
  config = {
    systemd.timers."${username}-git-scan" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "1h";
          Unit = "${username}-git-scan.service";
        };
    };

    systemd.services."${username}-git-scan" = {
      script = ''
        set -xu
        ${pkgs.findutils}/bin/find "''${HOME}" -name ".git" -type d 2>/dev/null | tee "${temporary-file}"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = username;
      };
    };

    users.users.${username}.packages = [
      (pkgs.writeShellScriptBin "dirtygit" ''
        set -e
        mapfile -t REPOS < ${temporary-file}
        for REPO in ''${REPOS[@]}
        do
            REPO_SUBSTR=''${REPO%/.git}
            GIT_RESULT=$(${pkgs.git}/bin/git -c "color.ui=always" -C ''${REPO_SUBSTR} status -s)
            if [[ ''${GIT_RESULT} ]]
            then
                echo "Repo ''${REPO_SUBSTR} dirty:"
                echo "''${GIT_RESULT}"
            fi
        done
      '')
    ];
  };
}
