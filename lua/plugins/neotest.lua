-- lua/plugins/neotest.lua

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-go",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        ["neotest-go"] = {
          args = { "-count=1", "-timeout=60s" },
        },
      },

      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },

      summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
        open = "botright vsplit | vertical resize 60",
      },

      floating = {
        border = "rounded",
      },

      diagnostic = {
        enabled = true,
      },
    })
  end,
}
