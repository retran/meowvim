-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/utils/hooks.lua
-- @brief: Utility functions for managing Neovim hooks and events.

local M = {}

local function update_title()
  local mode = vim.api.nvim_get_mode().mode
  local mode_map = {
    n = "[N]",
    no = "[N]",
    ni = "[N]",
    nt = "[N]",
    i = "[I]",
    ic = "[I]",
    ix = "[I]",
    v = "[V]",
    V = "[L]",
    ["\22"] = "[B]",
    c = "[:]",
    cv = "[:]",
    ce = "[:]",
    s = "[S]",
    S = "[S]",
    t = "[T]",
    r = "[R]",
    R = "[R]",
  }
  local mode_indicator = mode_map[mode] or ""

  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " [RO]" or ""
  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
  local user_host = string.format(" -- %s@%s", vim.env.USER or "user", vim.fn.hostname() or "host")

  vim.o.titlestring = string.format("meowvim | %s%s%s %s%s", filename, modified, readonly, mode_indicator, user_host)
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("WindowTitleUpdater", { clear = true })
  vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "FileChangedRO", "TextChanged" }, {
    group = augroup,
    pattern = "*",
    callback = update_title,
  })
end

return M
