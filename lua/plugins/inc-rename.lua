-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/inc-rename.lua
-- @brief: Live LSP rename with incremental preview via noice popup.
-- noice.lua has presets.inc_rename = true which routes :IncRename through
-- noice's command-line UI for a live-preview rename experience.

return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  keys = {
    {
      "<leader>cr",
      function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename Symbol",
    },
  },
  opts = {},
}
