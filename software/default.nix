{ ... }:
{
  imports = [
    ((import ./neovim) ["joris"])
    ./vesktop
    ./wm
    ./browser.nix
    ./cups.nix
    ./display-manager.nix
    ./logitech.nix
    ./pipewire.nix
    ./shell.nix
    ./virt.nix
    ./zerotier.nix
  ];
}
