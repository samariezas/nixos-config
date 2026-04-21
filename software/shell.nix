{ config, lib, pkgs, ... }:
{
  options = with lib; {
    pevcas.shell.color = mkOption {
      description = "Color for hostname in zsh";
      type = types.str;
    };
  };
  config = {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      # grml-zsh-config according to https://discourse.nixos.org/t/using-zsh-with-grml-config-and-nix-shell-prompt-indicator/13838
      enable = true;
      promptInit = ""; # otherwise it'll override the grml prompt
      interactiveShellInit = ''
        # Note that loading grml's zshrc here will override NixOS settings such as
        # `programs.zsh.histSize`, so they will have to be set again below.
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        HISTSIZE=10000000

        # disable sad smiley on non-zero exit
        zstyle ':prompt:grml:right:setup' items

        # Add nix-shell indicator that makes clear when we're in nix-shell.
        # Set the prompt items to include it in addition to the defaults:
        # Described in: http://bewatermyfriend.org/p/2013/003/
        function nix_shell_prompt () {
          REPLY=''${IN_NIX_SHELL+"(nix-shell) "}
        }
        grml_theme_add_token nix-shell-indicator -f nix_shell_prompt '%F{magenta}' '%f'
        zstyle ':prompt:grml:left:setup' items rc nix-shell-indicator change-root user at host path vcs percent

        zstyle ':prompt:grml:left:items:user' pre '''
        zstyle ':prompt:grml:left:items:host' pre '%F{${config.pevcas.shell.color}}'
        zstyle ':prompt:grml:left:items:host' post '%f'

        if [[ -x $(which dirtygit) ]]
        then
            dirtygit || echo "Dirtygit failed"
        fi
      '';
    };
    programs.tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      extraConfig = ''
        set-option -g default-shell ${pkgs.zsh}/bin/zsh
        set-option -g status-bg colour239
        set-option -g status-fg white
      '';
    };
  };
}
