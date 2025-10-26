#!/usr/bin/env bash
# Helper script to update 1Password versions in overlay

set -e

OVERLAY_FILE="overlays/1password.nix"

echo "Fetching latest 1Password versions..."

# Get latest GUI version from releases page
echo ""
echo "Visit https://releases.1password.com/linux/ to find the latest GUI version"
read -p "Enter latest GUI version (e.g., 8.11.14): " GUI_VERSION

# Get latest CLI version from updates page
echo ""
echo "Visit https://app-updates.agilebits.com/product_history/CLI2 to find the latest CLI version"
read -p "Enter latest CLI version (e.g., 2.32.0): " CLI_VERSION

echo ""
echo "Fetching hashes..."

# Fetch GUI hash
echo "Fetching 1Password GUI hash..."
GUI_URL="https://downloads.1password.com/linux/tar/stable/x86_64/1password-${GUI_VERSION}.x64.tar.gz"
GUI_HASH_BASE32=$(nix-prefetch-url "$GUI_URL" 2>/dev/null || echo "FAILED")

if [ "$GUI_HASH_BASE32" = "FAILED" ]; then
    echo "Error: Could not fetch GUI hash. Check the version number."
    exit 1
fi

# Convert to SRI format
GUI_HASH=$(nix hash convert --hash-algo sha256 --to sri "$GUI_HASH_BASE32" 2>/dev/null || echo "FAILED")

if [ "$GUI_HASH" = "FAILED" ]; then
    echo "Error: Could not convert GUI hash to SRI format."
    exit 1
fi

# Fetch CLI hash
echo "Fetching 1Password CLI hash..."
CLI_URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${CLI_VERSION}/op_linux_amd64_v${CLI_VERSION}.zip"
CLI_HASH_BASE32=$(nix-prefetch-url "$CLI_URL" 2>/dev/null || echo "FAILED")

if [ "$CLI_HASH_BASE32" = "FAILED" ]; then
    echo "Error: Could not fetch CLI hash. Check the version number."
    exit 1
fi

# Convert to SRI format
CLI_HASH=$(nix hash convert --hash-algo sha256 --to sri "$CLI_HASH_BASE32" 2>/dev/null || echo "FAILED")

if [ "$CLI_HASH" = "FAILED" ]; then
    echo "Error: Could not convert CLI hash to SRI format."
    exit 1
fi

echo ""
echo "Summary:"
echo "  GUI Version: $GUI_VERSION"
echo "  GUI Hash: $GUI_HASH"
echo "  CLI Version: $CLI_VERSION"
echo "  CLI Hash: $CLI_HASH"
echo ""

# Update overlay file
cat > "$OVERLAY_FILE" << EOF
final: prev: {
  # Override 1Password GUI to use the latest version
  _1password-gui = prev._1password-gui.overrideAttrs (finalAttrs: previousAttrs: {
    version = "${GUI_VERSION}";
    src = prev.fetchurl {
      url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-\${finalAttrs.version}.x64.tar.gz";
      hash = "${GUI_HASH}";
    };
  });

  # Override 1Password CLI to use the latest version
  _1password-cli = prev._1password-cli.overrideAttrs (finalAttrs: previousAttrs: {
    version = "${CLI_VERSION}";
    src = prev.fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op2/pkg/v\${finalAttrs.version}/op_linux_amd64_v\${finalAttrs.version}.zip";
      hash = "${CLI_HASH}";
    };
  });
}
EOF

echo "✓ Updated $OVERLAY_FILE"
echo ""
echo "Next steps:"
echo "  1. Review the changes: cat $OVERLAY_FILE"
echo "  2. Rebuild your system: sudo nixos-rebuild switch"
