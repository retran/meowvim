-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: bin/check-docs.lua
-- @brief: Verify that the documentation only names mappings and commands that exist.
--
-- Run with: nvim --headless -c "luafile bin/check-docs.lua"
--
-- It has to run after startup, not through `nvim -l`, because `-l` executes the
-- script without loading the configuration, so no mapping exists yet.
--
-- Documentation drifts away from a configuration one rename at a time, and the
-- drift is invisible until someone follows an instruction that no longer works.
-- This reads every `<leader>x` and `:Command` out of the docs and checks it
-- against the running configuration.

local DOCS = {
  "README.md",
  "TODO.md",
  "docs/01-INSTALLATION.md",
  "docs/02-CONFIGURATION.md",
  "docs/03-WORKFLOWS.md",
  "docs/04-TROUBLESHOOTING.md",
  "docs/KEYMAPS.md",
  "docs/KEYMAPS_QUICK_REFERENCE.md",
  "doc/meowvim.txt",
}

-- Commands that belong to Neovim, to a tool meowvim shells out to, or that the
-- docs name to say they are absent.
local EXTERNAL_COMMANDS = {
  Lazy = true,
  LspInfo = true,
  LspLog = true,
  LspRestart = true,
  LspStart = true,
  LspStop = true,
  TSInstall = true,
  Telescope = true,
}

local function read(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end
  local text = fd:read("a")
  fd:close()
  return text
end

--- Every prefix which-key renders as a group, which is not a mapping itself.
local function which_key_groups()
  local groups = {}
  local ok, wk = pcall(require, "which-key.config")
  if not ok then
    return groups
  end
  for _, mapping in ipairs(wk.mappings or {}) do
    if mapping.group and mapping.lhs then
      groups[mapping.lhs] = true
    end
  end
  return groups
end

--- Commands a lazy spec declares, which do not exist until the plugin loads.
local function lazy_commands()
  local commands = {}
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    return commands
  end
  for _, plugin in ipairs(lazy.plugins()) do
    local cmd = plugin.cmd
    if type(cmd) == "string" then
      commands[cmd] = true
    elseif type(cmd) == "table" then
      for _, name in ipairs(cmd) do
        commands[name] = true
      end
    end
  end
  return commands
end

local function run()
  local groups = which_key_groups()
  local declared = lazy_commands()
  local leader = vim.g.mapleader or " "
  local problems = {}

  local function mapping_exists(suffix)
    local lhs = leader .. suffix
    for _, mode in ipairs({ "n", "v", "x", "o", "t" }) do
      if vim.fn.maparg(lhs, mode) ~= "" then
        return true
      end
    end
    return false
  end

  for _, path in ipairs(DOCS) do
    local text = read(path)
    if not text then
      table.insert(problems, path .. ": missing")
    else
      local seen = {}

      for suffix in text:gmatch("<leader>([%w<>%-%[%]/%.,;:+=%*%$%%&#@!%?]+)") do
        -- Trim the punctuation that ends a sentence rather than a mapping.
        suffix = suffix:gsub("[%)%.,;:%?!]+$", "")
        local full = "<leader>" .. suffix
        if suffix ~= "" and not seen[full] and not groups[full] and not mapping_exists(suffix) then
          seen[full] = true
          table.insert(problems, ("%s: %s is not mapped"):format(path, full))
        end
      end

      for name in text:gmatch("`:(%u[%w]*)") do
        if
          not seen[name]
          and not EXTERNAL_COMMANDS[name]
          and not declared[name]
          and vim.fn.exists(":" .. name) ~= 2
        then
          seen[name] = true
          table.insert(problems, ("%s: :%s does not exist"):format(path, name))
        end
      end
    end
  end

  if #problems > 0 then
    io.stderr:write(table.concat(problems, "\n") .. "\n")
    vim.cmd("cquit 1")
  end

  io.stdout:write(("Checked %d documents; every mapping and command exists.\n"):format(#DOCS))
  vim.cmd("qa!")
end

-- Bring the configuration to the state a real session reaches. Opening a file
-- loads the plugins that hang off BufReadPre, such as nvim-lint and its
-- commands, and the mappings are registered through which-key, which flushes
-- its queue on VeryLazy.
pcall(vim.cmd.edit, "README.md")
pcall(vim.api.nvim_exec_autocmds, "User", { pattern = "VeryLazy", modeline = false })

local waited = 0
local timer = assert(vim.uv.new_timer())
timer:start(
  100,
  100,
  vim.schedule_wrap(function()
    waited = waited + 100
    local ok, wk = pcall(require, "which-key.config")
    local ready = ok and #(wk.mappings or {}) > 0
    if ready or waited >= 10000 then
      timer:stop()
      timer:close()
      if not ready then
        io.stderr:write("which-key registered no mappings within 10 seconds\n")
        vim.cmd("cquit 1")
      end
      run()
    end
  end)
)
