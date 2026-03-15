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

    map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put After Cursor" })
    map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Before Cursor" })
    map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put After and Move Cursor" })
    map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put Before and Move Cursor" })

    map("n", "<M-n>", "<Plug>(YankyNextEntry)", { desc = "Cycle to Next Yank" })
    map("n", "<M-p>", "<Plug>(YankyPreviousEntry)", { desc = "Cycle to Previous Yank" })

    map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put After with Indent" })
    map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Before with Indent" })
    map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put After with Indent" })
    map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Before with Indent" })

    map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put After and Shift Right" })
    map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put After and Shift Left" })
    map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = "Put Before and Shift Right" })
    map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = "Put Before and Shift Left" })

    map("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put After with Filter" })
    map("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put Before with Filter" })
  end,
}
