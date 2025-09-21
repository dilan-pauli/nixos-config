{ pkgs-unstable, ... }:

{
  programs.vscode = {
    enable = true;

    # VSCode profiles separate settings/extensions per workflow
    profiles.default.userSettings = {
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        
        # Nix language server configuration
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        
        # Direnv integration
        "direnv.restart.automatic" = true;
        
        # Development environment settings
        "python.defaultInterpreterPath" = ".venv/bin/python";
        "python.terminal.activateEnvironment" = true;
    };

    # Extensions are managed declaratively - no manual installation
    profiles.default.extensions = with pkgs-unstable.vscode-extensions; [
      ms-python.python # Official Microsoft Python extension
      bbenoist.nix     # Nix language support
      mkhl.direnv      # Direnv integration for automatic environment loading
      jnoortheen.nix-ide # Enhanced Nix language support
    ];
  };

  # Enable Catppuccin theming for VS Code
  catppuccin.vscode.profiles.default.enable = true;
}