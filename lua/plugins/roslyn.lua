-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

return {
  "seblyng/roslyn.nvim",
  config = function(_, opts)
    if vim.fn.executable("roslyn-language-server") ~= 1 then
      return
    end

    require("roslyn").setup(opts)
  end,
}
