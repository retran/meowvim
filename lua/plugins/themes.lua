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

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
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
