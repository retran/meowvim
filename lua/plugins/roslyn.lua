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
      return
    end

    require("roslyn").setup(opts)
  end,
}
