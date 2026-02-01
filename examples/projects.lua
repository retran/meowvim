-- Example projects configuration for Meowvim
-- Save this file as: ~/.config/meowvim/projects.lua

return {
  myproject = {
    path = "~/workspace/myproject",
    
    -- Optional: Override theme for this project
    theme = "tokyonight",
    variant = "storm",
    
    -- Optional: Set day/night themes for this project
    day_theme = "catppuccin",
    day_variant = "latte",
    night_theme = "tokyonight",
    night_variant = "storm",
    
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
    day_theme = "github",
    day_variant = "github_light",
    night_theme = "github",
    night_variant = "github_dark",
    on_open = "cd src",
  },
}
