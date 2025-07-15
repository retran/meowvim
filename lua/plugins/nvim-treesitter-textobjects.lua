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
            ["ab"] = { query = "@block.outer", desc = "around block" },
            ["ib"] = { query = "@block.inner", desc = "inside block" },
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
            ["at"] = { query = "@return.outer", desc = "around return" },
            ["it"] = { query = "@return.inner", desc = "inside return" },
            ["iS"] = { query = "@scopename.inner", desc = "inside scopename" },
            ["as"] = { query = "@statement.outer", desc = "around statement" },
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
