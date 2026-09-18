-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/overseer.lua
-- @brief: Task runner integration using overseer.nvim.

-- `vim.fs.find` matches names exactly unless it is given a predicate, so
-- extension patterns have to be expressed as a function. The .NET template
-- used to pass "*.sln" / "*.csproj" as plain strings and therefore never
-- matched, hiding the template even inside a .NET project.
local function find_root(names)
  local match = vim.fs.find(names, { upward = true, path = vim.fn.getcwd(), limit = 1 })[1]
  if match then
    return vim.fs.dirname(match)
  end
end

local function has_project_file(names)
  return find_root(names) ~= nil
end

local function by_extension(...)
  local suffixes = { ... }
  return function(name)
    for _, suffix in ipairs(suffixes) do
      if name:sub(-#suffix) == suffix then
        return true
      end
    end
    return false
  end
end

local DOTNET_PROJECT = by_extension(".sln", ".csproj")

return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerRun",
    "OverseerToggle",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerRunCmd",
    "OverseerOpen",
    "OverseerClose",
  },
  dependencies = {
    {
      "akinsho/toggleterm.nvim",
      opts = { direction = "float" },
    },
  },
  opts = {
    strategy = {
      "toggleterm",
      direction = "float",
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    local TAG = require("overseer.constants").TAG

    ---@param name string
    ---@param tag string
    ---@param root string|string[]|fun(name: string): boolean
    ---@param cmd string[]
    local function register(name, tag, root, cmd)
      overseer.register_template({
        name = name,
        tags = { tag },
        condition = {
          callback = function()
            return has_project_file(root)
          end,
        },
        builder = function()
          return {
            cmd = cmd,
            cwd = find_root(root) or vim.fn.getcwd(),
            components = { "default", "unique" },
          }
        end,
      })
    end

    register("npm run dev", TAG.BUILD, { "package.json" }, { "npm", "run", "dev" })
    register("npm test", TAG.TEST, { "package.json" }, { "npm", "test" })
    register("go test ./...", TAG.TEST, { "go.mod" }, { "go", "test", "./..." })
    register("dotnet build", TAG.BUILD, DOTNET_PROJECT, { "dotnet", "build" })
  end,
}
