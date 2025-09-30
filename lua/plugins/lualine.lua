-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: lua/plugins/lualine.lua
-- @brief: Customizable statusline with Git, LSP, and mode indicators.
-- @author: Andrew Vasilyev
-- @license: MIT
--
local dependencies = {
  "nvim-tree/nvim-web-devicons",
  "lewis6991/gitsigns.nvim",
}

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

if Meow.enable_copilot then
  local copilot = {
    "copilot",
    symbols = {
      status = {
        icons = {
          enabled = "",
          sleep = "",
          disabled = "",
          warning = "",
          unknown = "",
        },
        hl = {
          enabled = "#50FA7B",
          sleep = "#AEB7D0",
          disabled = "#6272A4",
          warning = "#FFB86C",
          unknown = "#FF5555",
        },
      },
      spinners = "dots",
      spinner_color = "#6272A4",
    },
    show_colors = true,
    show_loading = true,
  }

  table.insert(dependencies, 1, "AndreM222/copilot-lualine")
  table.insert(lualine_x, 2, copilot)
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = dependencies,
  opts = {
    options = {
      theme = Meow.theme,

      icons_enabled = true,

      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      ignore_focus = {},
      refresh = {
        statusline = 50,
        winbar = 50,
      },

      always_divide_middle = true,
      globalstatus = true,

      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
    },
    tabline = {},
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
    extensions = { "lazy", "nvim-tree" },
  },
}
