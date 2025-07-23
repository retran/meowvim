-- lua/plugins/leap.lua

return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = { "tpope/vim-repeat" },
  config = function()
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    vim.keymap.set({ "n", "x", "o" }, "<leader><space>", "<Plug>(leap)")
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    vim.keymap.set({ "n", "x", "o" }, "f", function()
      require("leap").leap({ inputlen = 1, inclusive_op = true })
    end)
    vim.keymap.set({ "n", "x", "o" }, "F", function()
      require("leap").leap({ inputlen = 1, inclusive_op = true, backward = true })
    end)
    vim.keymap.set({ "n", "x", "o" }, "t", function()
      require("leap").leap({ inputlen = 1, offset = -1 })
    end)
    vim.keymap.set({ "n", "x", "o" }, "T", function()
      require("leap").leap({ inputlen = 1, offset = 2, backward = true })
    end)
    require("leap.user").set_repeat_keys(";", ",", {
      relative_directions = false,
    })

  end,
}
