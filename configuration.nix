# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, thirdparty, ... }:
{
  imports =
    [
      ./machine-configs
      ./secrets
      ./core
      ./software
      ./user
      ./backuper
      ./dirty-git.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  services.fstrim.enable = true;

  boot.tmp.useTmpfs = true;

  networking.hostName = config.pevcas.systemHostname;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = "all";
  environment.variables = {
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.upower.enable = true;

  programs.pulseview.enable = true;
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joris = {
    openssh.authorizedKeys.keyFiles = [ ./ssh/thinkpad_yubikey.pub ];
    isNormalUser = true;
    description = "Joris";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" ];
    useDefaultShell = true;
  };

  programs.ssh.startAgent = true;

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
    ethtool

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
    vlc
    transmission_4-gtk
    signal-desktop
    telegram-desktop
    inkscape
    obs-studio

    waypipe

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
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", OWNER:="joris", MODE="0664"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", OWNER:="joris", MODE="0664"
  '';

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };
}
