-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/lazygit.lua
-- @brief: LazyGit integration with automatic theme synchronization

return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
  },
  config = function()
    -- Function to sync Neovim theme to LazyGit
    local function sync_lazygit_theme()
      local config_ok, config = pcall(require, "meowvim.config")
      if not config_ok then
        return
      end

      local theme = config.get("core.theme", "catppuccin")
      local variant = config.get("core.variant", "mocha")
      
      -- Map Neovim themes to LazyGit themes
      local theme_map = {
        catppuccin = {
          mocha = "catppuccin-mocha",
          latte = "catppuccin-latte",
          frappe = "catppuccin-frappe",
          macchiato = "catppuccin-macchiato",
        },
        tokyonight = "tokyonight",
        ["rose-pine"] = "rose-pine",
        gruvbox = "gruvbox",
        nord = "nord",
        kanagawa = "kanagawa",
      }
      
      local lazygit_theme = theme_map[theme]
      if type(lazygit_theme) == "table" then
        lazygit_theme = lazygit_theme[variant] or lazygit_theme[1]
      end
      
      -- Check if lazygit config exists
      local config_paths = {
        vim.fn.expand("~/.config/lazygit/config.yml"),
        vim.fn.expand("~/.config/jesseduffield/lazygit/config.yml"),
      }
      
      local config_path = nil
      for _, path in ipairs(config_paths) do
        if vim.fn.filereadable(path) == 1 then
          config_path = path
          break
        end
      end
      
      if not config_path then
        -- Create default config if it doesn't exist
        config_path = config_paths[1]
        local config_dir = vim.fn.fnamemodify(config_path, ":h")
        vim.fn.mkdir(config_dir, "p")
      end
      
      -- Read existing config or create new one
      local lines = {}
      if vim.fn.filereadable(config_path) == 1 then
        lines = vim.fn.readfile(config_path)
      end
      
      -- Update or add theme setting
      local theme_found = false
      for i, line in ipairs(lines) do
        if line:match("^%s*theme:") then
          lines[i] = string.format("  theme: %s", lazygit_theme or "default")
          theme_found = true
          break
        end
      end
      
      if not theme_found then
        -- Add theme to gui section
        local gui_found = false
        for i, line in ipairs(lines) do
          if line:match("^gui:") then
            table.insert(lines, i + 1, string.format("  theme: %s", lazygit_theme or "default"))
            gui_found = true
            break
          end
        end
        
        if not gui_found then
          table.insert(lines, "gui:")
          table.insert(lines, string.format("  theme: %s", lazygit_theme or "default"))
        end
      end
      
      -- Write config back
      vim.fn.writefile(lines, config_path)
    end
    
    -- Sync theme on LazyGit startup
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyGitOpen",
      callback = sync_lazygit_theme,
    })
    
    -- Also sync when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = sync_lazygit_theme,
    })
  end,
}
