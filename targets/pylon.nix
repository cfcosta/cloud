{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/267a2e89-f17c-4ae8-ba84-709fda2a95aa";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0B55-0450";
    fsType = "vfat";
  };

  networking.hostName = "pylon";

  swapDevices = [ ];
}
