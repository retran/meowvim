-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/auto-save.lua
-- @brief: Automatic file saving when leaving insert mode or text changes.

return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    debounce_delay = 1500,
    write_all_buffers = true,
    lockmarks = true,
    condition = function(buf)
      local excluded_filetypes = {
        "gitcommit",
        "toggleterm",
        "lazy",
        "snacks_picker_list",
      }

      if vim.fn.getbufvar(buf, "&buftype") ~= "" then
        return false
      end

      if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then
        return false
      end

      return true
    end,
  },
}
