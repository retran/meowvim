-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-tabline.lua
-- @brief: Minimal and fast tabline showing listed buffers

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
