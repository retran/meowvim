-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/roslyn.lua
-- @brief: Plugin for C# development using Roslyn

return {
  "seblyng/roslyn.nvim",
  init = function()
    require("config.mason").ensure_servers({ "roslyn" })
  end,
  -- Use Mason's roslyn wrapper script
  opts = {
    exe = "roslyn",
  },
  config = function(_, opts)
    if vim.fn.executable(opts.exe) ~= 1 then
      vim.notify(
        string.format(
          "[roslyn.nvim] Executable '%s' not found. Install Roslyn via Mason with ':MasonInstall roslyn'.",
          opts.exe
        ),
        vim.log.levels.ERROR
      )
      return
    end
    require("roslyn").setup(opts)
  end,
}
