# NixOS Configuration Style and Conventions

## File Organization
- **flake.nix**: Main entry point with inputs/outputs
- **configuration.nix**: System-wide settings
- **home/*.nix**: User-specific module configurations
- **theme/theme.nix**: Centralized color/styling definitions

## Nix Style Guidelines
- Use descriptive comments explaining purpose
- Organize imports logically (system inputs first)
- Group related configurations together
- Use `specialArgs` to pass variables between modules
- Prefer modular approach over monolithic files

## Package Management Patterns
- Use `pkgs` for stable packages (system reliability)
- Use `pkgs-unstable` for latest development tools
- Mix sources strategically in `home/packages.nix`
- Use `writeShellScriptBin` for custom scripts

## Naming Conventions
- Kebab-case for hostnames: `larry-desktop`
- Snake_case for Nix variables: `pkgs-unstable`
- Descriptive module names: `waybar.nix`, `hyprland.nix`

## Theme Integration
- All modules receive `theme` as specialArgs
- Colors defined once in `theme/theme.nix`
- Consistent styling across all applications

## Environment Variables
- Use `~/.env` file for secrets/API keys
- Shell configuration auto-sources environment
- Use `create-env` script for interactive setup
- Set proper permissions: `chmod 600 ~/.env`