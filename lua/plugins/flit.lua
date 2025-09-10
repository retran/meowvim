-- lua/plugins/flit.lua

return {
  "ggandor/flit.nvim",
  event = "VeryLazy",
  dependencies = { "ggandor/leap.nvim" },
  config = function()
    require("flit").setup({
      keys = { f = "f", F = "F", t = "t", T = "T" },
      labeled_modes = "nvo",
      clever_repeat = true,
      multiline = true,
      opts = {},
    })
  end,
}
