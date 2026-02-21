# configuration.nix
{ config, pkgs, pkgs-unstable, theme, ... }:

{
  imports = [
    ./hardware-configuration.nix # Auto-generated hardware config
    ./system-packages.nix # System-wide packages
    ./mounts.nix # Filesystem mount configuration
    ./home.nix # Home-manager configuration
    ./display_manager.nix # SDDM display manager with Catppuccin theme
  ];

  # Bootloader - systemd-boot is simpler than GRUB
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "larry-desktop";
  networking.networkmanager.enable = true; # GUI network management
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
    networkmanager-openconnect
  ];
  
  # Disable IPv6 to prevent VPN leaks
  networking.enableIPv6 = false;

  # Firewall configuration
  networking.firewall = {
    enable = true;
  };

  # DNS resolution service for caching and security
  services.resolved.enable = true;
  
  # Enable UPower for power management information
  services.upower.enable = true;

  # Timezone and Locale
  time.timeZone = "America/Regina";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Sound via Pipewire (modern replacement for PulseAudio)
  services.pulseaudio.enable = false; # Disable old audio system
  security.rtkit.enable = true; # Real-time scheduling for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # 32-bit app support
    pulse.enable = true; # PulseAudio compatibility
  };

  # User account configuration
  users.users.noquarter = {
    isNormalUser = true;
    description = "Dilan Pauli";
    extraGroups = [ "networkmanager" "wheel" ]; # wheel = sudo access
  };

  programs.zsh.enable = true; # Enable Zsh system-wide
  
  # SSH agent disabled - using 1Password SSH agent instead
  programs.ssh.startAgent = false;

  # Home-Manager configuration - manages user environment
  home-manager = {
    useGlobalPkgs = true; # Use system nixpkgs
    useUserPackages = true; # Install to user profile
    backupFileExtension = "backup"; # Backup existing files instead of failing
    extraSpecialArgs = { inherit pkgs-unstable theme; }; # Pass variables to home config
    users.noquarter = { ... }: {
      # User configuration defined in home.nix
    };
  };

  # Nix configuration
  nix.settings.trusted-users = [ "root" "noquarter" ]; # Users who can configure Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enable new Nix CLI
  nix.settings.download-buffer-size = 134217728; # 128MB download buffer (default: 64MB)
  
  # Development environment optimization
  nix.settings.keep-outputs = true; # Keep build outputs for development shells
  nix.settings.keep-derivations = true; # Keep derivations for development shells
  
  nixpkgs.config.allowUnfree = true; # Allow proprietary software

  # Automatic garbage collection - runs daily and keeps only last 3 days
  nix.gc = {
    automatic = true;
    dates = "daily"; # Run every day at 03:15
    options = "--delete-older-than 3d"; # Keep only last 3 days (very aggressive)
  };
  
  # Run user garbage collection alongside system cleanup
  systemd.user.services.nix-gc-user = {
    description = "Nix Garbage Collector (User)";
    script = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 3d";
    serviceConfig = {
      Type = "oneshot";
      User = "noquarter";
    };
  };
  
  systemd.user.timers.nix-gc-user = {
    description = "Nix Garbage Collection Timer (User)";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1800"; # 30min random delay
      Persistent = true;
    };
  };

  # Automatic store optimization to reduce disk usage
  nix.settings.auto-optimise-store = true;

  # Automatic system updates disabled - manual updates on Sundays
  system.autoUpgrade.enable = false;

  # TODO Replace with Niri
  # Hyprland window manager (Wayland-based)
  # Note: Package version is managed in home/hyprland.nix via home-manager
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true; # X11 app compatibility

  # XDG Desktop Portal for proper Wayland app integration
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Enable PAM authentication for screen locking
  security.pam.services.hyprlock = {};

  # Enable gnome-keyring for 1Password secret storage
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Enable automatic trim
  services.fstrim.enable = true;

  # Graphics configuration for gaming and GPU acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkForce true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver    # LIBVA_DRIVER_NAME=iHD
      libva-vdpau-driver
      libvdpau-va-gl
      mesa
      nvidia-vaapi-driver
      nv-codec-headers-12
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      libva-vdpau-driver
      mesa
      libvdpau-va-gl
    ];
  };

  # Enable swap for better memory pressure handling
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8*1024; # 8GB swap file
  } ];

  # Ensure NFS state directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/nfs 0755 root root"
    "d /var/lib/nfs/sm 0755 root root"
    "d /var/lib/nfs/sm.bak 0755 root root"
  ];

  system.stateVersion = "25.11";
}
