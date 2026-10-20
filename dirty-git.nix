{ pkgs, ... }:
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
        ${pkgs.findutils}/bin/find "''${HOME}" -xdev -name .git -prune -printf '%h\n' -o -type d -name '.*' -prune 2>/dev/null | tee "${temporary-file}"
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
            if [ ! -d ''${REPO} ]
            then
                echo "Repo ''${REPO} doesn't exist, skipping"
                continue
            fi
            GIT_RESULT=$(${pkgs.git}/bin/git -c "color.ui=always" -C ''${REPO} status -s)
            if [[ ''${GIT_RESULT} ]]
            then
                echo "Repo ''${REPO} dirty:"
                echo "''${GIT_RESULT}"
            fi
        done
      '')
    ];
  };
}
