-- File: lua/plugins/indent-blankline.lua

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  main = "ibl",
  opts = {
    enabled = false,
    indent = {
      char = "│",
    },
    scope = { enabled = true },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "lazy",
      },
      buftypes = { "terminal" },
    },
  },
}
