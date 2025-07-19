return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      transparent = not vim.g.neovide,
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
