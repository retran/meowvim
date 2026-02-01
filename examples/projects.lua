-- Example projects configuration for Meowvim
-- Save this file as: ~/.config/meowvim/projects.lua

return {
  myproject = {
    path = "~/workspace/myproject",
    
    -- Optional: Override theme for this project
    theme = "tokyonight",
    variant = "storm",
    
    -- Optional: Run command when opening project
    on_open = "Roslyn start",
    
    -- Optional: Disable inheriting main config settings
    inherit = true,
  },
  
  dotfiles = {
    path = "~/.config",
    theme = "gruvbox",
    variant = "medium",
  },
  
  work = {
    path = "$HOME/work/bigproject",
    theme = "github",
    variant = "github_dark",
    on_open = "cd src",
  },
}

