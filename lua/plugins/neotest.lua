-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/neotest.lua
-- @brief: Framework for running and displaying test results interactively.
--
-- Rust tests: neotest-rust was archived August 2025. Use rustaceanvim's
-- built-in :RustLsp testables / :RustLsp runnables instead.

return {
  "nvim-neotest/neotest",
  cmd = "Neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    -- Go
    "nvim-neotest/neotest-go",
    -- Python (pytest, unittest, doctest)
    "nvim-neotest/neotest-python",
    -- JavaScript / TypeScript (vitest)
    "marilari88/neotest-vitest",
    -- JavaScript / TypeScript (jest)
    "nvim-neotest/neotest-jest",
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
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = function()
            -- prefer virtualenv python if present
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            return vim.fn.filereadable(venv) == 1 and venv or "python3"
          end,
        }),
        require("neotest-vitest"),
        require("neotest-jest")({
          jestCommand = "npx jest --",
          jestConfigFile = function()
            local cwd = vim.fn.getcwd()
            for _, name in ipairs({ "jest.config.ts", "jest.config.js", "jest.config.cjs" }) do
              if vim.fn.filereadable(cwd .. "/" .. name) == 1 then
                return cwd .. "/" .. name
              end
            end
          end,
          env = { CI = "true" },
          cwd = function()
            return vim.fn.getcwd()
          end,
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
