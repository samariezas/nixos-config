{ config, pkgs, lib, ... }:
{
    config = {
        programs.virt-manager.enable = true;
        virtualisation.libvirtd.enable = true;
        virtualisation.spiceUSBRedirection.enable = true;
        users.groups.libvirtd.members = [ "joris" ];
        users.users.joris.extraGroups = [ "libvirtd" ];
        home-manager.users.joris = { pkgs, ... }:
        {
            dconf.settings = {
                "org/virt-manager/virt-manager/connections" = {
                    autoconnect = ["qemu:///system"];
                    uris = ["qemu:///system"];
                };
            };
        };

        # iommu
        # boot.kernelParams = [ "intel_iommu=on" ];
        # boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
        # boot.extraModprobeConfig = "options vfio-pci ids=1106:3483";
    };
}
