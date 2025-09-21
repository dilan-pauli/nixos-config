# Project Overview: NixOS Configuration

## Purpose
This is a personal NixOS configuration repository using flakes and Home Manager for a Hyprland-based Wayland desktop environment. It provides a complete, reproducible system configuration with a focus on:
- Keyboard-driven workflow 
- Consistent theming across all applications
- Gaming and development capabilities
- Modular, maintainable configuration structure

## Tech Stack
- **NixOS**: Declarative Linux distribution
- **Nix Flakes**: Modern dependency management and reproducible builds
- **Home Manager**: User environment management
- **Hyprland**: Wayland window manager
- **Waybar**: Status bar
- **Catppuccin**: Consistent theming framework

## Key Architecture
- Dual package sources: stable (25.05) for system reliability, unstable for latest development tools
- Centralized theming system in `theme/theme.nix`
- Modular configuration split into focused files in `home/` directory
- Environment variables loaded from `~/.env` file
- Custom scripts using `writeShellScriptBin` pattern

## Target System
- Hostname: `larry-desktop`
- Platform: x86_64-linux
- Graphics: NVIDIA proprietary drivers
- Audio: PipeWire
- Desktop: Hyprland with XWayland compatibility