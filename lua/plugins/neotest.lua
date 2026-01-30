-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/neotest.lua
-- @brief: Framework for running and displaying test results interactively.

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-go",
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
          dap_go_enabled = true,
        }),
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
