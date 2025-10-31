-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to do so, subject to the following conditions:
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
-- @file: lua/plugins/yanky.lua
-- @brief: Enhanced yank/put experience with Snacks picker integration.
-- author: Andrew Vasilyev
-- @license: MIT
--
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

    map("n", "<leader>p?", function()
      local ok, snacks = pcall(require, "yanky.sources.snacks")
      if ok then
        snacks.pick()
      else
        vim.notify("Snacks picker is unavailable", vim.log.levels.WARN)
      end
    end, { desc = "Yank History" })
  end,
}
