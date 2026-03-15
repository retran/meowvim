-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/keymap_checker.lua
-- @brief: Keymap conflict detection and analysis tool

local M = {}

-- Get all keymaps for a mode
local function get_keymaps(mode)
  local keymaps = vim.api.nvim_get_keymap(mode)
  local buf_keymaps = vim.api.nvim_buf_get_keymap(0, mode)
  
  -- Merge global and buffer-local keymaps
  local all_keymaps = {}
  for _, km in ipairs(keymaps) do
    table.insert(all_keymaps, vim.tbl_extend("force", km, { scope = "global" }))
  end
  for _, km in ipairs(buf_keymaps) do
    table.insert(all_keymaps, vim.tbl_extend("force", km, { scope = "buffer" }))
  end
  
  return all_keymaps
end

-- Find duplicate/conflicting keymaps
local function find_conflicts()
  local modes = { "n", "i", "v", "x", "s", "o", "t", "c" }
  local conflicts = {}
  
  for _, mode in ipairs(modes) do
    local keymaps = get_keymaps(mode)
    local seen = {}
    
    for _, km in ipairs(keymaps) do
      local lhs = km.lhs or ""
      if seen[lhs] then
        table.insert(conflicts, {
          mode = mode,
          lhs = lhs,
          maps = { seen[lhs], km },
        })
      else
        seen[lhs] = km
      end
    end
  end
  
  return conflicts
end

-- Format keymap info
local function format_keymap(km)
  local parts = {}
  
  if km.desc and km.desc ~= "" then
    table.insert(parts, string.format('"%s"', km.desc))
  end
  
  if km.callback then
    table.insert(parts, "<Lua function>")
  elseif km.rhs then
    table.insert(parts, string.format('-> %s', km.rhs))
  end
  
  if km.buffer and km.buffer ~= 0 then
    table.insert(parts, string.format('[buf:%d]', km.buffer))
  end
  
  if km.scope then
    table.insert(parts, string.format('[%s]', km.scope))
  end
  
  return #parts > 0 and table.concat(parts, " ") or "<no info>"
end

-- Display conflicts in a buffer
function M.show_conflicts()
  local conflicts = find_conflicts()
  
  if #conflicts == 0 then
    vim.notify("No keymap conflicts detected!", vim.log.levels.INFO)
    return
  end
  
  -- Create new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, "Keymap Conflicts")
  
  -- Build content
  local lines = {
    "# Keymap Conflicts Detected",
    "",
    string.format("Found %d potential conflicts:", #conflicts),
    "",
  }
  
  for i, conflict in ipairs(conflicts) do
    table.insert(lines, string.format("## Conflict %d: [%s] %s", i, conflict.mode, conflict.lhs))
    for j, km in ipairs(conflict.maps) do
      table.insert(lines, string.format("  %d. %s", j, format_keymap(km)))
    end
    table.insert(lines, "")
  end
  
  -- Set content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
  
  -- Open in split
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

-- List all keymaps for a mode
function M.list_keymaps(mode)
  mode = mode or "n"
  local keymaps = get_keymaps(mode)
  
  if #keymaps == 0 then
    vim.notify(string.format("No keymaps found for mode '%s'", mode), vim.log.levels.INFO)
    return
  end
  
  -- Sort by lhs
  table.sort(keymaps, function(a, b)
    return (a.lhs or "") < (b.lhs or "")
  end)
  
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, string.format("Keymaps [%s]", mode))
  
  -- Build content
  local lines = {
    string.format("# Keymaps for mode: %s", mode),
    "",
    string.format("Total: %d keymaps", #keymaps),
    "",
  }
  
  for _, km in ipairs(keymaps) do
    local lhs = km.lhs or "<unknown>"
    local info = format_keymap(km)
    table.insert(lines, string.format("%-20s %s", lhs, info))
  end
  
  -- Set content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
  
  -- Open in split
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
end

-- Register commands
vim.api.nvim_create_user_command("KeymapConflicts", function()
  M.show_conflicts()
end, { desc = "Show keymap conflicts" })

vim.api.nvim_create_user_command("KeymapList", function(opts)
  local mode = opts.args ~= "" and opts.args or "n"
  M.list_keymaps(mode)
end, {
  desc = "List all keymaps for a mode",
  nargs = "?",
  complete = function()
    return { "n", "i", "v", "x", "s", "o", "t", "c" }
  end,
})

return M
