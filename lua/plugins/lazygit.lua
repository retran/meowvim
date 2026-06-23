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
  config = function()
    local function sync_lazygit_theme()
      local config_ok, config = pcall(require, "meowvim.config")
      if not config_ok then
        return
      end

      local theme = config.get("core.theme", "catppuccin")
      local variant = config.get("core.variant", "mocha")

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
        config_path = config_paths[1]
        local config_dir = vim.fn.fnamemodify(config_path, ":h")
        vim.fn.mkdir(config_dir, "p")
      end

      local lines = {}
      if vim.fn.filereadable(config_path) == 1 then
        lines = vim.fn.readfile(config_path)
      end

      local theme_found = false
      for i, line in ipairs(lines) do
        if line:match("^%s*theme:") then
          lines[i] = string.format("  theme: %s", lazygit_theme or "default")
          theme_found = true
          break
        end
      end

      if not theme_found then
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

      vim.fn.writefile(lines, config_path)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyGitOpen",
      callback = sync_lazygit_theme,
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = sync_lazygit_theme,
    })
  end,
}
