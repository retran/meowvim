-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/silicon.lua
-- @brief: Code screenshot generation tool with beautiful syntax highlighting

return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  keys = {
    { "<leader>cs", "<cmd>Silicon<cr>", mode = "v", desc = "Create Code Screenshot" },
  },
  config = function()
    -- Every other external-tool integration in this config gates on the binary;
    -- silicon did not, so <leader>cs failed with a command-not-found error.
    if vim.fn.executable("silicon") ~= 1 then
      return
    end

    local function hl_bg(name, fallback)
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      return (hl and hl.bg) and string.format("#%06x", hl.bg) or fallback
    end

    require("silicon").setup({
      font = "JetBrainsMono Nerd Font=34",
      theme = "Dracula",
      -- Follows the active colorscheme instead of a hardcoded catppuccin teal.
      background = hl_bg("Visual", "#94e2d5"),
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
      end,
      line_number = true,
      pad_horiz = 80,
      pad_vert = 60,
      line_offset = function(args)
        return args.line1
      end,
      output = function()
        return "~/Pictures/Screenshots/code_" .. os.date("%Y%m%d_%H%M%S") .. ".png"
      end,
      gobble = true,
      tab_width = 2,
      shadow_blur_radius = 16,
      shadow_offset_x = 8,
      shadow_offset_y = 8,
      shadow_color = "#100808",
    })
  end,
}
