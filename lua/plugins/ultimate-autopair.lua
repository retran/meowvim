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

    -- Add blacklisted filetypes
    local filetype_ext = config.extensions.filetype
    filetype_ext.nft = filetype_ext.nft or {}
    local seen = {}
    for _, ft in ipairs(filetype_ext.nft) do
      seen[ft] = true
    end

    for _, ft in ipairs({ "snacks_terminal", "snacks_input", "snacks_picker_input", "snacks_picker_list" }) do
      if not seen[ft] then
        table.insert(filetype_ext.nft, ft)
      end
    end

    local configs = { config }
    local cmp_ok, cmpair = pcall(require, "ultimate-autopair.experimental.cmpair")
    if cmp_ok then
      table.insert(configs, { profile = cmpair.init })
    end

    autopair.init(configs)
  end,
}
