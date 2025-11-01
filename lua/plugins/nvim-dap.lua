-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-dap.lua
-- @brief: Debug Adapter Protocol (DAP) client for debugging integration.

require("config.mason").ensure_debuggers({ "delve", "netcoredbg" })

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mason-org/mason.nvim",
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      config = function()
        local dapui = require("dapui")
        dapui.setup()
        local dap = require("dap")
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "leoluz/nvim-dap-go",
      config = function()
        require("dap-go").setup()
      end,
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- netcoredbg adapter
    dap.adapters.coreclr = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.adapters.godot = {
      type = "server",
      host = "127.0.0.1",
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
      },
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch .NET",
        request = "launch",
        program = function()
          return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
      {
        type = "coreclr",
        name = "Attach to process",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    local dap_context_maps = {
      {
        "n",
        "<leader>rt",
        function()
          dap.terminate()
        end,
        "Terminate",
      },
      {
        "n",
        "<leader>rb",
        function()
          dap.toggle_breakpoint()
        end,
        "Toggle Breakpoint",
      },
      {
        "n",
        "<leader>rs",
        function()
          dap.step_over()
        end,
        "Step Over",
      },
      {
        "n",
        "<leader>ri",
        function()
          dap.step_into()
        end,
        "Step Into",
      },
      {
        "n",
        "<leader>ro",
        function()
          dap.step_out()
        end,
        "Step Out",
      },
      {
        "n",
        "<leader>ru",
        function()
          dapui.toggle()
        end,
        "Toggle UI",
      },
      {
        { "n", "v" },
        "<leader>rh",
        function()
          require("dap.ui.widgets").hover()
        end,
        "Hover Variable",
      },
      {
        "n",
        "<leader>rg",
        function()
          dap.run_to_cursor()
        end,
        "Go to Cursor",
      },
      {
        "n",
        "<leader>rR",
        function()
          dap.repl.open()
        end,
        "Open REPL",
      },
      {
        "n",
        "<leader>rBc",
        function()
          dap.set_breakpoint(vim.fn.input("Condition: "))
        end,
        "Conditional Breakpoint",
      },
      {
        "n",
        "<leader>rBl",
        function()
          dap.set_breakpoint(nil, nil, vim.fn.input("Log Message: "))
        end,
        "Log Point",
      },
      {
        "n",
        "<leader>rBd",
        function()
          dap.clear_breakpoints()
        end,
        "Delete All Breakpoints",
      },
      {
        "n",
        "<leader>rBe",
        function()
          dap.set_exception_breakpoints()
        end,
        "Exception Breakpoints",
      },
      {
        "n",
        "<leader>rUs",
        function()
          require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
        end,
        "Scopes",
      },
      {
        "n",
        "<leader>rUf",
        function()
          require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames)
        end,
        "Frames",
      },
      {
        { "n", "v" },
        "<leader>rUp",
        function()
          require("dap.ui.widgets").preview()
        end,
        "Preview Variable",
      },
    }

    local function register_dap_maps()
      for _, map in ipairs(dap_context_maps) do
        vim.keymap.set(map[1], map[2], map[3], { desc = map[4] })
      end
    end

    register_dap_maps()

    vim.keymap.set("n", "<leader>rr", function()
      dap.continue()
    end, { desc = "Run / Continue" })
  end,
}
