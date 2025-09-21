# Essential Commands for NixOS Configuration

## System Management
```bash
# Apply configuration changes (primary method)
sudo nixos-rebuild switch

# Apply with explicit flake path
sudo nixos-rebuild switch --flake ~/nixos-config#larry-desktop

# Test changes without applying
sudo nixos-rebuild dry-build

# Build without switching
sudo nixos-rebuild build
```

## Development Workflow
```bash
# Update flake dependencies
nix flake update

# Check flake configuration
nix flake check

# Show flake structure
nix flake show
```

## Maintenance
```bash
# Manual cleanup
sudo nix-collect-garbage -d        # System-wide
nix-collect-garbage -d             # User environment

# Force scheduled services
sudo systemctl start nix-gc.service
sudo systemctl start nixos-upgrade.service
```

## Custom Scripts Available
```bash
screenshot select|full      # Screenshots
create-env                  # Environment setup
lametric-notify "message"   # Device notifications
waybar-temps               # Temperature monitoring
find-temp-sensors          # Discover sensors
```

## Standard Linux Commands
All standard Linux utilities available: `git`, `ls`, `cd`, `grep`, `find`, `cat`, `vim`, etc.