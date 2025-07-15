return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    require("ts_context_commentstring").setup({
      enable_autocmd = true,
    })

    require("Comment").setup({
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "<leader>cc",
        block = "<leader>cb",
      },
      opleader = {
        line = "<leader>cC",
        block = "<leader>cB",
      },
      extra = {
        above = "<leader>cO",
        below = "<leader>co",
        eol = "<leader>cA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
    })
  end,
}
