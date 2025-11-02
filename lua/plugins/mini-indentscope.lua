-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/mini-indentscope.lua
-- @brief: Minimal indent guides with animation-free rendering.

local toggles = require("utils.toggles")

return {
  "echasnovski/mini.indentscope",
  version = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
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

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "lazy",
        "snacks_terminal",
        "snacks_input",
        "snacks_picker",
        "snacks_picker_input",
        "snacks_picker_list",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
