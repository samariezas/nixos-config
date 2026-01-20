# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./machine-configs

      ./wm
      ./neovim
      ./gaming
      ./virt.nix
      ./dirty-git.nix
    ];

  wmconfig.users = [ "joris" "gaming" ];
  neovimconfig.users = [ "joris" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  services.fstrim.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./vesktop.patch
        ];
      });
    })
  ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      minegrub-world-sel = {
        enable = true;
        customIcons = [{
          name = "nixos";
          lineTop = "NixOS (18/06/2025, 09:23)";
          lineBottom = "Survival Mode, No Cheats";
          imgName = "nixos";
        }];
      };
    };
  };

  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = "all";
  environment.variables = {
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "minesddm";
  };
  services.upower.enable = true;

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

  programs.pulseview.enable = true;
  programs.kdeconnect.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joris = {
    openssh.authorizedKeys.keyFiles = [ ./ssh/thinkpad_yubikey.pub ];
    isNormalUser = true;
    description = "Joris";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" ];
    useDefaultShell = true;
  };

  programs.ssh.startAgent = true;

  home-manager.users.joris = { pkgs, ... }:
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

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    git
    ripgrep
    wl-clipboard
    restic
    unzip
    file
    qemu
    wine-staging
    gdu
    btop
    dig
    dos2unix
    e2fsprogs
    ffmpeg
    fzf
    gnuplot
    iotop
    mpv
    pavucontrol
    usbutils
    squashfsTools
    stlink
    stress
    whois
    xournalpp
    zip
    p7zip

    python3
    python3Packages.ipython
    gdb
    valgrind
    perf

    libreoffice
    zathura
    gimp
    feh
    kitty
    qalculate-gtk
    mpv
    yubikey-personalization
    yubikey-manager
    openconnect

    killall
    htop
    nix-search-cli
    nh
    ranger
    vesktop
    vlc
    transmission_4-gtk
    signal-desktop
    telegram-desktop

    linux-manual
    man-pages
    man-pages-posix

    libnotify
    jmtpfs

    debootstrap
    parted
    expect

    distrobox

    (pkgs.callPackage ./minesddm.nix { })
  ];

  system.extraDependencies = with pkgs; [
    gcc
    rustc
    cargo
    zig
  ];

  environment.variables.EDITOR = "vim";

  documentation = {
    enable = true;
    man = {
      enable = true;
      man-db.enable = true;
      generateCaches = false;
    };
    dev.enable = true;
  };

  # stm32 usb
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", OWNER:="joris", SYMLINK+="stlinkv2-1_%n"
  '';

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
