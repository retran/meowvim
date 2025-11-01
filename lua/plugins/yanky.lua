-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/yanky.lua
-- @brief: Enhanced yank/put experience with Snacks picker integration.

return {
  "gbprod/yanky.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("yanky").setup(opts)

    local map = vim.keymap.set

    map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
    map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

    map("n", "<C-n>", "<Plug>(YankyNextEntry)")
    map("n", "<C-p>", "<Plug>(YankyPreviousEntry)")

    map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
    map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
    map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
    map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

    map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
    map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
    map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
    map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

    map("n", "=p", "<Plug>(YankyPutAfterFilter)")
    map("n", "=P", "<Plug>(YankyPutBeforeFilter)")
 end,
}
