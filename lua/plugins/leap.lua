-- lua/plugins/leap.lua

return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    vim.keymap.set({ "n", "x", "o" }, "<leader><space>", "<Plug>(leap)")
    vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
    vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
    vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
  end,
}
