{ pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.foo2zjs
  ];
}
