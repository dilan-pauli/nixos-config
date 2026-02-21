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
  # NFS mounts for NAS
  fileSystems."/mnt/pictures" = {
    device = "192.168.50.253:/Pictures";
    fsType = "nfs";
    options = [ 
      "rw"
      "vers=4"
      "_netdev"
      "bg"
    ];
  };

  fileSystems."/mnt/media" = {
    device = "192.168.50.253:/Multimedia";
    fsType = "nfs";
    options = [ 
      "rw"
      "vers=4"
      "_netdev"
      "bg"
    ];
  };
}