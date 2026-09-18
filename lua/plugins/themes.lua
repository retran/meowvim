-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/themes.lua
-- @brief: lazy.nvim specs for every bundled colorscheme.
--
-- The themes themselves are described once in `meowvim.themes`; this file only
-- turns that table into plugin specs. Only the theme selected in the user
-- config loads at startup — the rest are installed but stay lazy, so the theme
-- picker, the day/night pairs and the presets can pull any of them in on demand
-- without paying for them on every launch.

local themes = require("meowvim.themes")

local active_theme = (function()
  local ok, config = pcall(require, "meowvim.config")
  return ok and config.get("core.theme", "catppuccin") or "catppuccin"
end)()

local specs = {}

for name, theme in pairs(themes.themes) do
  local spec = {
    theme.repo,
    name = theme.name,
    dependencies = theme.dependencies,
    priority = 1000,
    lazy = name ~= active_theme,
  }

  if name == active_theme then
    spec.config = function()
      local ok, config = pcall(require, "meowvim.config")
      local variant = ok and config.get("core.variant", nil) or nil
      theme.apply(variant, themes.transparency())
    end
  end

  table.insert(specs, spec)
end

-- Ensure Copilot ghost text uses the theme's Comment color (muted, visually distinct)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    local fg = comment_hl.fg
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = fg, italic = true })
    vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = fg, italic = true })
  end,
})

return specs
