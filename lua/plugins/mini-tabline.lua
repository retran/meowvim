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
-- @file: lua/plugins/mini-tabline.lua
-- @brief: Minimal and fast tabline showing listed buffers
-- @author: Andrew Vasilyev
-- @license: MIT
--
return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.tabline").setup({
      -- Whether to show file icons (requires 'nvim-tree/nvim-web-devicons')
      show_icons = true,

      -- Function which formats the tab label
      -- By default, returns filename relative to current directory
      set_vim_settings = true,

      -- Whether to set Vim's settings for tabline (enable displaying of tabline)
      tabpage_section = "right",
    })

    -- Catppuccin Mocha colors for tabline
    local colors = {
      base = "#1e1e2e",
      surface0 = "#313244",
      surface1 = "#45475a",
      text = "#cdd6f4",
      subtext0 = "#a6adc8",
      sky = "#89dceb",
      sapphire = "#74c7ec",
      overlay0 = "#6c7086",
    }

    -- Set up highlight groups for tabline without cursive or underlines
    vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
      fg = colors.sky,
      bg = colors.surface1,
      bold = true,
    })

    vim.api.nvim_set_hl(0, "MiniTablineVisible", {
      fg = colors.text,
      bg = colors.surface0,
    })

    vim.api.nvim_set_hl(0, "MiniTablineHidden", {
      fg = colors.subtext0,
      bg = colors.base,
    })

    vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
      fg = colors.sky,
      bg = colors.surface1,
      bold = true,
    })

    vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
      fg = colors.text,
      bg = colors.surface0,
    })

    vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
      fg = colors.subtext0,
      bg = colors.base,
    })

    vim.api.nvim_set_hl(0, "MiniTablineFill", {
      bg = colors.base,
    })

    vim.api.nvim_set_hl(0, "MiniTablineTabpagesection", {
      fg = colors.sapphire,
      bg = colors.surface0,
      bold = true,
    })
  end,
}
