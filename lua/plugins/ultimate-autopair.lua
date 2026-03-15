-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/ultimate-autopair.lua
-- @brief: Advanced autopairing with Treesitter-aware behaviour and CMP integration.

return {
  "altermo/ultimate-autopair.nvim",
  branch = "v0.6",
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local autopair = require("ultimate-autopair")
    local config = autopair.extend_default()

    config.bs.enable = true

    config.tabout = {
      enable = true,
      map = "<A-Tab>",
      cmap = "<A-Tab>",
      hopout = true,
      do_nothing_if_fail = true,
    }

    config.fastwarp = {
      enable = true,
      map = "<A-e>",
      rmap = "<A-E>",
      nocursormove = true,
      multiline = true,
      do_nothing_if_fail = true,
    }

    config.close = {
      enable = true,
      map = "<A-)>",
      cmap = "<A-)>",
      do_nothing_if_fail = true,
    }

    config.space.enable = true

    config.cr = {
      enable = true,
      autoclose = true,
    }

    local configs = { config }
    local cmp_ok, cmpair = pcall(require, "ultimate-autopair.experimental.cmpair")
    if cmp_ok then
      table.insert(configs, { profile = cmpair.init })
    end

    autopair.init(configs)
  end,
}
