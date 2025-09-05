# system-packages.nix - System-wide packages
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nfs-utils   # For NFS filesystem support
    cifs-utils  # For SMB/CIFS filesystem support
    openvpn     # OpenVPN client for Surfshark
    wireguard-tools # WireGuard VPN tools
    networkmanagerapplet # GUI for NetworkManager VPN
    podman      # Container runtime
    podman-tui  # Terminal UI for Podman
    podman-compose # Docker Compose compatibility
  ];

  # Podman configuration for rootless containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Docker compatibility
    defaultNetwork.settings.dns_enabled = true;
  };

  # System-wide font configuration for better rendering
  fonts = {
    enableDefaultPackages = true;
    
    # Font optimization settings
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight"; # Better for LCD screens
      };
      subpixel = {
        rgba = "rgb"; # For RGB subpixel layout (most common)
        lcdfilter = "default";
      };
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "JetBrains Mono" ];
        sansSerif = [ "Inter" "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };
    
    packages = with pkgs; [
      inter # Better system font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-serif
    ];
  };
}