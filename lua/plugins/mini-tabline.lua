-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-tabline.lua
-- @brief: Minimal and fast tabline showing listed buffers

return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.tabline").setup({
      show_icons = true,
      set_vim_settings = true,
      tabpage_section = "right",
    })

    local function apply_catppuccin_highlights()
      local ok, palettes = pcall(require, "catppuccin.palettes")
      if not ok then
        return
      end

      local flavour = vim.g.catppuccin_flavour or "mocha"
      local colors = palettes.get_palette(flavour)
      if not colors then
        return
      end

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
    end

    apply_catppuccin_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("meowvim-mini-tabline", { clear = true }),
      callback = apply_catppuccin_highlights,
    })
  end,
}
