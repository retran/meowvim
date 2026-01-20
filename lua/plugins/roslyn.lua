-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/roslyn.lua
-- @brief: Plugin for C# development using Roslyn

return {
  "seblyng/roslyn.nvim",
  init = function()
    require("config.mason").ensure_servers({ "roslyn" })
  end,
  opts = {
    exe = "roslyn", -- Use Mason's roslyn wrapper script (installed via Mason and available on $PATH)
  },
  config = function(_, opts)
    if vim.fn.executable(opts.exe) ~= 1 then
      vim.notify(
        string.format(
          "[roslyn.nvim] Executable '%s' not found. Ensure Roslyn is installed via Mason and its wrapper script is available in $PATH.",
          opts.exe
        ),
        vim.log.levels.ERROR
      )
      return
    end
    require("roslyn").setup(opts)
  end,
}
