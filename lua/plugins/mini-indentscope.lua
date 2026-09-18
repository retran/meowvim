-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-indentscope.lua
-- @brief: Minimal indent guides with animation-free rendering.

return {
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local toggles = require("utils.toggles")
    local indentscope = require("mini.indentscope")

    indentscope.setup({
      draw = {
        animation = indentscope.gen_animation.none(),
      },
      symbol = "│",
      options = {
        try_as_border = true,
      },
    })

    toggles.ensure("miniindentscope_disable")

    -- Buffers where a scope indicator is noise rather than information.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("meowvim-indentscope-disable", { clear = true }),
      pattern = {
        "bigfile",
        "checkhealth",
        "dap-repl",
        "gitcommit",
        "help",
        "lazy",
        "man",
        "neotest-summary",
        "qf",
        "snacks_dashboard",
        "snacks_input",
        "snacks_notif",
        "snacks_picker",
        "snacks_picker_input",
        "snacks_picker_list",
        "snacks_terminal",
        "toggleterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
