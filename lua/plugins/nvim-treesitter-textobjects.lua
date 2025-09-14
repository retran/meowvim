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
-- @file: lua/plugins/nvim-treesitter-textobjects.lua
-- @brief: Neovim plugin configuration for treesitter textobjects.
-- @author: Andrew Vasilyev
-- @license: MIT
--
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = false,
          keymaps = {
            ["a="] = { query = "@assignment.outer", desc = "around assignment" },
            ["i="] = { query = "@assignment.inner", desc = "inside assignment" },
            ["al"] = { query = "@assignment.lhs", desc = "around assignment lhs" },
            ["ar"] = { query = "@assignment.rhs", desc = "around assignment rhs" },
            ["a@"] = { query = "@attribute.outer", desc = "around attribute" },
            ["i@"] = { query = "@attribute.inner", desc = "inside attribute" },
            ["am"] = { query = "@block.outer", desc = "around major block" },
            ["im"] = { query = "@block.inner", desc = "inside major block" },
            ["aC"] = { query = "@call.outer", desc = "around call" },
            ["iC"] = { query = "@call.inner", desc = "inside call" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a/"] = { query = "@comment.outer", desc = "around comment" },
            ["i/"] = { query = "@comment.inner", desc = "inside comment" },
            ["ao"] = { query = "@conditional.outer", desc = "around conditional" },
            ["io"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["aF"] = { query = "@frame.outer", desc = "around frame" },
            ["iF"] = { query = "@frame.inner", desc = "inside frame" },
            ["af"] = { query = "@function.outer", desc = "around function" },
            ["if"] = { query = "@function.inner", desc = "inside function" },
            ["aL"] = { query = "@loop.outer", desc = "around loop" },
            ["iL"] = { query = "@loop.inner", desc = "inside loop" },
            ["in"] = { query = "@number.inner", desc = "inside number" },
            ["aa"] = { query = "@parameter.outer", desc = "around parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "inside parameter" },
            ["ax"] = { query = "@regex.outer", desc = "around regex" },
            ["ix"] = { query = "@regex.inner", desc = "inside regex" },
            ["aR"] = { query = "@return.outer", desc = "around return" }, -- 'R' для Return
            ["iR"] = { query = "@return.inner", desc = "inside return" },
            ["iS"] = { query = "@scopename.inner", desc = "inside scopename" },
            ["aS"] = { query = "@statement.outer", desc = "around statement" }, -- 'S' для Statement
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function" },
            ["]c"] = { query = "@class.outer", desc = "Next class" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
            ["]b"] = { query = "@block.outer", desc = "Next block" },
            ["]L"] = { query = "@loop.outer", desc = "Next loop" },
            ["]o"] = { query = "@conditional.outer", desc = "Next conditional" },
            ["]C"] = { query = "@call.outer", desc = "Next call" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function" },
            ["[c"] = { query = "@class.outer", desc = "Previous class" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
            ["[b"] = { query = "@block.outer", desc = "Previous block" },
            ["[L"] = { query = "@loop.outer", desc = "Previous loop" },
            ["[o"] = { query = "@conditional.outer", desc = "Previous conditional" },
            ["[C"] = { query = "@call.outer", desc = "Previous call" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>Ta"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<leader>TA"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
          },
        },
      },
    })

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
  end,
}
