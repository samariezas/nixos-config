# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
# let
#   secrets = import ./secrets.nix;
# in
{
  imports =
    [
      ./hardware-configuration.nix

      ./wm
      ./neovim
      ./gaming
      # ./backuper
      ./virt.nix
    ];

  wmconfig.users = [ "joris" "gaming" ];
  neovimconfig.users = [ "joris" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement.cpuFreqGovernor = "performance";

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
      useOSProber = false;
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

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/ae98b94b-9bb0-426d-bf0f-15b10f7b48dc";
      preLVM = true;
      allowDiscards = true;
    };
  };

  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.loader.systemd-boot.enable = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # time.timeZone = "Europe/Vilnius";
  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
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
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.autoswitch-profile" = false;
      };
    };
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
      userName = "Joris Pevcevičius";
      userEmail = "joris.pevcas@gmail.com";
      extraConfig = {
        credential.helper = "store";
      };
    };
    programs.ssh = {
      enable = true;
      # matchBlocks.storage = {
      #   hostname = secrets.backup.hostname;
      #   user = secrets.backup.username;
      #   port = secrets.backup.port;
      #   extraOptions = {
      #     ControlPath = "~/.ssh/master-%r@%n:%p";
      #     ControlMaster = "auto";
      #     ControlPersist = "10m";
      #   };
      # };
    };
    home.stateVersion = "25.05";
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
    xfce.thunar
    whois
    xournalpp
    zip
    p7zip

    python3
    python3Packages.ipython

    libreoffice
    zathura
    gimp
    feh
    kitty
    qalculate-gtk
    mpv
    yubikey-personalization
    yubikey-manager

    killall
    htop
    nix-search-cli
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
