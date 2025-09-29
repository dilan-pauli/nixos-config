{ config, pkgs, theme, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    
    settings = {
      
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
        linemode = "size";
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "${config.xdg.cacheHome}/yazi";
      };
    };

    keymap = {
      manager.prepend_keymap = [
        # Quick navigation
        { on = ["g" "h"]; run = "cd ~"; desc = "Go to home"; }
        { on = ["g" "d"]; run = "cd ~/Downloads"; desc = "Go to downloads"; }
        { on = ["g" "c"]; run = "cd ~/nixos-config"; desc = "Go to config"; }
        { on = ["g" "p"]; run = "cd ~/projects"; desc = "Go to projects"; }
        { on = ["g" "m"]; run = "cd /mnt"; desc = "Go to /mnt"; }
        
        # File operations
        { on = ["<C-n>"]; run = "shell 'touch \"$0\"' --block --confirm"; desc = "Create new file"; }
        { on = ["<C-d>"]; run = "shell 'mkdir -p \"$0\"' --block --confirm"; desc = "Create directory"; }
        
        # Open with external programs
        { on = ["e"]; run = "shell 'nvim \"$@\"' --block --confirm"; desc = "Open in Neovim"; }
        { on = ["o"]; run = "shell 'xdg-open \"$@\"' --confirm"; desc = "Open with default app"; }
      ];
    };

  };

  # Enable Catppuccin theme for Yazi (new location)
  catppuccin.yazi.enable = true;
}