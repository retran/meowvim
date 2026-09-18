-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/nvim-dap.lua
-- @brief: Debug Adapter Protocol (DAP) client for debugging integration.
--
-- Adapters and launch configurations only; the <leader>d keymaps live in
-- lua/config/keymaps.lua, which is what lets this plugin stay lazy — it used to
-- register them here and therefore loaded on every startup together with
-- dap-ui, dap-go, dap-python, nvim-nio and dap-virtual-text.

return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
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
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        -- Use system python3 for the debugpy adapter binary; per-project
        -- pythonPath (what runs the program) is resolved lazily by dap-python
        -- via VIRTUAL_ENV, .venv, pyenv, etc. at session start.
        require("dap-python").setup("python3")
      end,
    },
  },
  config = function()
    local dap = require("dap")

    if vim.fn.executable("netcoredbg") == 1 then
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }
    end

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

    if vim.fn.executable("netcoredbg") == 1 then
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
    end
  end,
}
