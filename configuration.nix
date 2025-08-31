# configuration.nix
{ config, pkgs, pkgs-unstable, theme, ... }:

{
  imports = [
    ./hardware-configuration.nix # Auto-generated hardware config
    ./system-packages.nix # System-wide packages
    ./mounts.nix # Filesystem mount configuration
    ./home.nix # Home-manager configuration
    # ./ollama.nix # Local AI model server (heavy build!)
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
  
  # DNS resolution service for caching and security
  services.resolved.enable = true;
  
  # Enable UPower for power management information
  services.upower.enable = true;

  # Printing services - CUPS with Brother printer support
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser              # Brother laser printer driver (open source)
      brgenml1lpr          # Brother generic LPR driver
      brgenml1cupswrapper  # Brother generic CUPS wrapper
    ];
  };
  
  # Enable network printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Timezone and Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

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
  users.users.lrabbets = {
    isNormalUser = true;
    description = "Lawrence Rabbets";
    extraGroups = [ "networkmanager" "wheel" "ollama" ]; # wheel = sudo access
  };

  programs.zsh.enable = true; # Enable Zsh system-wide

  # Home-Manager configuration - manages user environment
  home-manager = {
    useGlobalPkgs = true; # Use system nixpkgs
    useUserPackages = true; # Install to user profile
    backupFileExtension = "backup"; # Backup existing files instead of failing
    extraSpecialArgs = { inherit pkgs-unstable theme; }; # Pass variables to home config
    users.lrabbets = { ... }: {
      # User configuration defined in home.nix
    };
  };

  # Nix configuration
  nix.settings.trusted-users = [ "root" "lrabbets" ]; # Users who can configure Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enable new Nix CLI
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
      User = "lrabbets";
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

  # Automatic system updates - pulls latest flake inputs and rebuilds
  system.autoUpgrade = {
    enable = true;
    dates = "04:30"; # Run daily at 4:30 AM
    randomizedDelaySec = "30min"; # Add up to 30min random delay to avoid load spikes
    allowReboot = false; # Don't automatically reboot (manual reboot required for kernel updates)
    flake = "github:lawrab/nixos-config"; # Your flake repository
  };

  # Hyprland window manager (Wayland-based)
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true; # X11 app compatibility
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  };

  # Enable PAM authentication for screen locking
  security.pam.services.hyprlock = {};

  # Enable automatic trim
  services.fstrim.enable = true;

  # Graphics configuration for gaming and GPU acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Wine/Steam Proton games
  };

  # Enable NVIDIA driver loading
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option "Coolbits" "28"
  '';

  # NVIDIA driver configuration
  hardware.nvidia = {
    modesetting.enable = true; # Required for Wayland
    open = false; # Use proprietary driver (better gaming performance)
    nvidiaSettings = true; # Include nvidia-settings GUI
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Stable driver version
    
    # Enable power management and persistence for GPU control
    powerManagement.enable = true;
    powerManagement.finegrained = false;
  };

  # Enable swap for better memory pressure handling
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8*1024; # 8GB swap file
  } ];

  # Fix NVIDIA device node creation
  services.udev.extraRules = ''
    KERNEL=="nvidia_uvm", OWNER="root", GROUP="video", MODE="0660"
    KERNEL=="nvidia*", OWNER="root", GROUP="video", MODE="0660"
    KERNEL=="nvidiactl", OWNER="root", GROUP="video", MODE="0660"
  '';

  # Ensure NFS state directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/nfs 0755 root root"
    "d /var/lib/nfs/sm 0755 root root"
    "d /var/lib/nfs/sm.bak 0755 root root"
  ];

  # GPU clock speed configuration via systemd service
  systemd.services.gpu-undervolt = {
    description = "GPU Undervolting Service";
    after = [ "graphical-session.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/nvidia-smi -lgc 1830";
      User = "root";
    };
  };

  system.stateVersion = "25.05";
}
