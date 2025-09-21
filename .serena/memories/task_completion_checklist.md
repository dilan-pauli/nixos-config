# Task Completion Checklist

## After Making Configuration Changes

### 1. Validate Configuration
```bash
# Check flake syntax and dependencies
nix flake check

# Test build without applying
sudo nixos-rebuild dry-build
```

### 2. Apply Changes
```bash
# Apply configuration changes
sudo nixos-rebuild switch

# Or with explicit path
sudo nixos-rebuild switch --flake ~/nixos-config#larry-desktop
```

### 3. Verify System State
- Check that services are running correctly
- Test new functionality
- Verify theme consistency if styling was changed
- Ensure environment variables are loaded correctly

### 4. Optional Cleanup
```bash
# Clean old generations if needed
sudo nix-collect-garbage -d
nix-collect-garbage -d
```

## Git Workflow
- Commit changes with descriptive messages
- Never reference AI tools in commit messages
- Focus on what changed and why

## Important Notes
- Configuration has automatic updates (daily) and garbage collection (weekly)
- System is designed to be self-maintaining
- Manual intervention only needed for major changes