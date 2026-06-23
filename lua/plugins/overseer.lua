-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/overseer.lua
-- @brief: Task runner integration using overseer.nvim.

local function find_root(patterns)
  local cwd = vim.fn.getcwd()
  local match = vim.fs.find(patterns, { upward = true, path = cwd, limit = 1 })[1]
  if match then
    return vim.fs.dirname(match)
  end
  return nil
end

local function has_project_file(patterns)
  return find_root(patterns) ~= nil
end

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
  opts = {},
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(vim.tbl_deep_extend("force", {
      strategy = {
        "toggleterm",
        direction = "float",
      },
      templates = { "builtin" },
    }, opts or {}))

    local TAG = require("overseer.constants").TAG

    local function register(template)
      overseer.register_template(template)
    end

    register({
      name = "npm run dev",
      tags = { TAG.BUILD },
      condition = {
        callback = function()
          return has_project_file({ "package.json" })
        end,
      },
      builder = function()
        local cwd = find_root({ "package.json" }) or vim.fn.getcwd()
        return {
          cmd = { "npm", "run", "dev" },
          cwd = cwd,
          components = { "default", "unique" },
        }
      end,
    })

    register({
      name = "npm test",
      tags = { TAG.TEST },
      condition = {
        callback = function()
          return has_project_file({ "package.json" })
        end,
      },
      builder = function()
        local cwd = find_root({ "package.json" }) or vim.fn.getcwd()
        return {
          cmd = { "npm", "test" },
          cwd = cwd,
          components = { "default", "unique" },
        }
      end,
    })

    register({
      name = "go test ./...",
      tags = { TAG.TEST },
      condition = {
        callback = function()
          return has_project_file({ "go.mod" })
        end,
      },
      builder = function()
        local cwd = find_root({ "go.mod" }) or vim.fn.getcwd()
        return {
          cmd = { "go", "test", "./..." },
          cwd = cwd,
          components = { "default", "unique" },
        }
      end,
    })

    register({
      name = "dotnet build",
      tags = { TAG.BUILD },
      condition = {
        callback = function()
          return has_project_file({ "*.sln", "*.csproj" })
        end,
      },
      builder = function()
        local cwd = find_root({ "*.sln", "*.csproj" }) or vim.fn.getcwd()
        return {
          cmd = { "dotnet", "build" },
          cwd = cwd,
          components = { "default", "unique" },
        }
      end,
    })
  end,
}
