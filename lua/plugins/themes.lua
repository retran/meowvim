-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

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

local function get_flavour()
  local ok, projects = pcall(require, "utils.projects")
  if not ok then
    return "macchiato"
  end
  local theme = projects.get_theme_for_cwd()

  local valid_flavours = {
    latte = true,
    frappe = true,
    macchiato = true,
    mocha = true,
  }

  if type(theme) == "string" and valid_flavours[theme] then
    return theme
  end

  return "macchiato"
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
