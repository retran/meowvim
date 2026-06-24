-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/lualine.lua
-- @brief: Customizable statusline with Git, LSP, and mode indicators.

-- Cache catppuccin palette; invalidated on ColorScheme so day/night toggles
-- pick up the correct colours without a restart.
local cached_palette = nil
local function get_palette()
  if not cached_palette then
    local flavour = vim.g.catppuccin_flavour or "mocha"
    local palettes_ok, palettes = pcall(require, "catppuccin.palettes")
    if palettes_ok then
      cached_palette = palettes.get_palette(flavour)
    else
      cached_palette = {
        green = "#a6e3a1",
        blue = "#89b4fa",
        overlay0 = "#6c7086",
        peach = "#fab387",
        red = "#f38ba8",
      }
    end
  end
  return cached_palette
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("meowvim-lualine-palette", { clear = true }),
  callback = function()
    cached_palette = nil
  end,
})

local function get_dependencies()
  return {
    "echasnovski/mini.icons",
    "AndreM222/copilot-lualine",
  }
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 1000,
  dependencies = get_dependencies(),
  opts = function()
    local enable_copilot = false
    if vim.g.copilot_enabled ~= nil then
      enable_copilot = vim.g.copilot_enabled
    else
      local config_ok, config = pcall(require, "meowvim.config")
      if config_ok then
        enable_copilot = config.get("core.enable_copilot", false)
      end
    end

    local lualine_x = {
      "diagnostics",
      "filetype",
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "LF",
          dos = "CRLF",
          mac = "CR",
        },
      },
    }

    if enable_copilot then
      local colors = get_palette()
      local copilot = {
        "copilot",
        symbols = {
          status = {
            icons = {
              enabled = "",
              sleep = "",
              disabled = "",
              warning = "",
              unknown = "",
            },
            hl = {
              enabled = colors.green,
              sleep = colors.blue,
              disabled = colors.overlay0,
              warning = colors.peach,
              unknown = colors.red,
            },
          },
          spinners = "dots",
          spinner_color = colors.blue,
        },
        show_colors = true,
        show_loading = true,
      }

      table.insert(lualine_x, 2, copilot)
    end

    return {
      options = {
        theme = "auto",
        icons_enabled = true,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        refresh = {
          statusline = 1000,
          winbar = 1000,
        },
        always_divide_middle = true,
        globalstatus = true,
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
      },
      winbar = {},
      inactive_winbar = {},
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          "branch",
          "diff",
          "gitsigns",
          { "filename", path = 1 },
        },
        lualine_x = lualine_x,
        lualine_y = {},
        lualine_z = {
          "progress",
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "progress", "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy" },
    }
  end,
}
