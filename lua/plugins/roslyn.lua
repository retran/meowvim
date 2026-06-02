-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

return {
  "seblyng/roslyn.nvim",
  opts = {
    exe = "roslyn",
  },
  config = function(_, opts)
    local exe = "roslyn"

    if vim.fn.executable(exe) ~= 1 then
      vim.notify(
        string.format(
          "[roslyn.nvim] Executable '%s' not found. Install Roslyn via mise or ensure it is on PATH.",
          exe
        ),
        vim.log.levels.WARN
      )
      return
    end

    require("roslyn").setup(opts)
  end,
}
