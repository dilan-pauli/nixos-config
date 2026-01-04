# mounts.nix - Filesystem mount configuration
{ ... }:

let
  # Common NFS mount options for rabnas
  nfsOptions = [
    "x-systemd.automount"        # Auto-mount on access
    "noauto"                     # Don't mount at boot
    "x-systemd.idle-timeout=60"  # Unmount after 60 seconds of inactivity
    "x-systemd.device-timeout=5s" # Timeout for device availability
    "x-systemd.mount-timeout=5s"  # Timeout for mount operation
  ];
in
{
  # NFS mounts for rabnas (Synology NAS)
  fileSystems."/mnt/rabnas/data" = {
    device = "rabnas.home:/volume1/data";
    fsType = "nfs";
    options = nfsOptions;
  };

  fileSystems."/mnt/rabnas/docker" = {
    device = "rabnas.home:/volume1/docker";
    fsType = "nfs";
    options = nfsOptions;
  };
}