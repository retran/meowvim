-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/themes.lua
-- @brief: Themes configuration.

local function is_headless()
  if not vim.v.argv then
    return false
  end
  for _, arg in ipairs(vim.v.argv) do
    if arg == "--headless" then
      return true
    end
  end
  return false
end

-- Get catppuccin flavour based on project config from ~/.meowvim.yaml
local function get_flavour()
  local ok, projects = pcall(require, "utils.projects")
  if not ok then
    return "macchiato" -- default if projects module fails
  end
  local theme = projects.get_theme_for_cwd()
  -- Return theme if found, otherwise default
  -- Validation happens in apply_theme_for_path
  return theme or "macchiato"
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local flavour = get_flavour()

    require("catppuccin").setup({
      flavour = flavour,
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = not vim.g.neovide and not is_headless(),
      default_integrations = true,
      auto_integrations = true,
      integrations = {
        lualine = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        which_key = true,
        snacks = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
