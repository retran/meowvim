-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @brief: Debug Adapter Protocol (DAP) client for debugging integration.
-- @author: Andrew Vasilyev
-- @license: MIT
--

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

    local mason_registry = require("mason-registry")
    local function get_netcoredbg()
      local ok, pkg = pcall(mason_registry.get_package, "netcoredbg")
      if not ok or not pkg:is_installed() then
        return nil
      end

      local uv = vim.uv or vim.loop
      local sysname = uv.os_uname().sysname:lower()
      local is_windows = sysname:find("windows") or sysname:find("mingw")

      local exe = is_windows and "netcoredbg.exe" or "netcoredbg"
      local install_path = pkg:get_install_path()
      local path = vim.fs.joinpath(install_path, exe)
      if vim.fn.filereadable(path) == 1 then
        return path
      end

      local shim = vim.fs.joinpath(
        vim.fn.stdpath("data"),
        "mason",
        "bin",
        "netcoredbg" .. (is_windows and ".cmd" or "")
      )
      local fallback = is_windows and shim or vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "netcoredbg")
      if vim.fn.filereadable(fallback) == 1 or vim.fn.executable(fallback) == 1 then
        return fallback
      end
    end

    local netcoredbg = get_netcoredbg()
    if not netcoredbg then
      vim.notify(
        "netcoredbg debugger not found. Install it with :MasonInstall netcoredbg.",
        vim.log.levels.WARN,
        { title = "DAP" }
      )
    end

    dap.adapters.coreclr = {
      type = "executable",
      command = netcoredbg or "netcoredbg",
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
        name = "Build and Launch .NET",
        request = "launch",
        console = "integratedTerminal",
        program = function()
          local project_path = vim.fn.input("Path to project: ", vim.fn.getcwd() .. "/", "file")

          if project_path == "" then
            return nil
          end

          local get_dll_path_command = "dotnet build '"
            .. project_path
            .. "' -nologo -v q --getProperty:TargetPath"

          local dll_path = vim.fn.system(get_dll_path_command)

          dll_path = vim.trim(dll_path)

          if vim.fn.filereadable(dll_path) == 1 then
            print("Debugger will launch: " .. dll_path)
            return dll_path
          else
            print("Error: Could not determine DLL path. Build failed or command returned empty.")
            return nil
          end
        end,
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
