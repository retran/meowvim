-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/hbac.lua
-- @brief: Automatic buffer closing to maintain optimal buffer count

return {
  "axkirillov/hbac.nvim",
  event = "VeryLazy",
  config = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local threshold = 10
    local auto_close_enabled = true

    if config_ok then
      threshold = config.get("performance.buffer_threshold", 10)
      auto_close_enabled = config.get("performance.buffer_auto_close", true)
    end

    if not auto_close_enabled then
      return
    end

    require("hbac").setup({
      autoclose = true,
      threshold = threshold,
      close_command = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
      close_buffers_with_windows = false,
    })
  end,
}
