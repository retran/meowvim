-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/meowvim/commands.lua
-- @brief: User commands for meowvim configuration management.

local M = {}

function M.setup()
  -- Edit main config
  vim.api.nvim_create_user_command("MeowvimConfig", function()
    vim.cmd("edit ~/.config/meowvim/config.lua")
  end, {
    desc = "Edit meowvim configuration",
  })

  -- Reload config
  vim.api.nvim_create_user_command("MeowvimConfigReload", function()
    local ok, err = pcall(function()
      require("meowvim.config").reload()
    end)

    if ok then
      vim.notify("⚙️  Config reloaded", vim.log.levels.INFO, { title = "Meowvim" })
    else
      vim.notify("❌ Config reload failed:\n" .. tostring(err), vim.log.levels.ERROR, { title = "Meowvim" })
    end
  end, {
    desc = "Reload meowvim configuration",
  })

  -- Validate config
  vim.api.nvim_create_user_command("MeowvimConfigValidate", function()
    local config = require("meowvim.config")
    local ok, errors = config.validate()

    if ok then
      vim.notify("✅ Configuration is valid", vim.log.levels.INFO, { title = "Meowvim" })
    else
      local msg = "❌ Configuration errors:\n\n" .. table.concat(errors, "\n")
      vim.notify(msg, vim.log.levels.ERROR, { title = "Meowvim" })
    end
  end, {
    desc = "Validate meowvim configuration",
  })

  -- Edit projects config
  vim.api.nvim_create_user_command("MeowvimProjects", function()
    vim.cmd("edit ~/.config/meowvim/projects.lua")
  end, {
    desc = "Edit projects configuration",
  })

  -- Switch to project
  vim.api.nvim_create_user_command("MeowvimProject", function(opts)
    require("meowvim.config").switch_project(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return require("meowvim.config").get_project_names()
    end,
    desc = "Switch to project by name",
  })

  -- Show current config
  vim.api.nvim_create_user_command("MeowvimConfigShow", function()
    local config = require("meowvim.config").get()
    print(vim.inspect(config))
  end, {
    desc = "Show current configuration",
  })

  -- Show current project
  vim.api.nvim_create_user_command("MeowvimProjectCurrent", function()
    local project = require("meowvim.config").current_project()
    if project then
      print("Current project: " .. project.name)
      print(vim.inspect(project))
    else
      print("No project detected for current directory")
    end
  end, {
    desc = "Show current project info",
  })
end

return M
