-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-treesitter-textobjects.lua
-- @brief: Treesitter textobjects configuration for enhanced code navigation.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    })

    -- Select textobjects keymaps
    local select = require("nvim-treesitter-textobjects.select")
    vim.keymap.set({ "x", "o" }, "af", function()
      select.select_textobject("@function.outer", "textobjects")
    end, { desc = "Select outer function" })
    vim.keymap.set({ "x", "o" }, "if", function()
      select.select_textobject("@function.inner", "textobjects")
    end, { desc = "Select inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
      select.select_textobject("@class.outer", "textobjects")
    end, { desc = "Select outer class" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      select.select_textobject("@class.inner", "textobjects")
    end, { desc = "Select inner class" })
    vim.keymap.set({ "x", "o" }, "aa", function()
      select.select_textobject("@parameter.outer", "textobjects")
    end, { desc = "Select outer parameter" })
    vim.keymap.set({ "x", "o" }, "ia", function()
      select.select_textobject("@parameter.inner", "textobjects")
    end, { desc = "Select inner parameter" })
    vim.keymap.set({ "x", "o" }, "al", function()
      select.select_textobject("@loop.outer", "textobjects")
    end, { desc = "Select outer loop" })
    vim.keymap.set({ "x", "o" }, "il", function()
      select.select_textobject("@loop.inner", "textobjects")
    end, { desc = "Select inner loop" })

    -- Move textobjects keymaps
    local move = require("nvim-treesitter-textobjects.move")
    vim.keymap.set({ "n", "x", "o" }, "]m", function()
      move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]M", function()
      move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "][", function()
      move.goto_next_end("@class.outer", "textobjects")
    end, { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "[m", function()
      move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous function start" })
    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous class start" })
    vim.keymap.set({ "n", "x", "o" }, "[M", function()
      move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous function end" })
    vim.keymap.set({ "n", "x", "o" }, "[]", function()
      move.goto_previous_end("@class.outer", "textobjects")
    end, { desc = "Previous class end" })

    -- Swap textobjects keymaps
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>S>", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "<leader>S<", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap with previous parameter" })
  end,
}
