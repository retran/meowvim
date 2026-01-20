-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/snacks.lua
-- @brief: Collection of useful utilities and UI components.

return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    dashboard = {
      width = 44,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Open Project", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = " ", key = "n", desc = "Create File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Show Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "q", desc = "Quit Neovim", action = ":qa" },
        },
        header = [[meowvim
-------]],
      },
      sections = {
        {
          pane = 1,
          height = 17,
          width = 40,
          padding = 1,
          section = "terminal",
          cmd = "~/.config/nvim/scripts/icon.sh",
        },
        {
          pane = 2,
          {
            section = "header",
            padding = 1,
          },
          {
            section = "projects",
            padding = 1,
          },
          {
            section = "keys",
            gap = 0,
            padding = 1,
          },
          {
            section = "startup",
            padding = 1,
          },
        },
      },
    },

    bigfile = {},
    dim = {},
    explorer = {
      replace_netrw = true,
    },
    input = {},
    notifier = {},
    terminal = {},
    image = { enabled = false },
    scope = { enabled = false },
    scratch = {
      ft = "markdown",
      filekey = {
        cwd = true,
        branch = false,
        count = true,
      },
    },
    styles = { enabled = false },

    picker = {
      hidden = true,
      layout = { preset = "ivy" },
      sources = {
        files = {
          hidden = true,
        },
        git_files = {
          hidden = true,
        },
        recent = {
          hidden = true,
        },
        explorer = {
          layout = {
            position = "right",
          },
          hidden = true,
          follow_file = true,
          auto_close = true,
          jump = {
            close = true,
          },
        },
        projects = {
          hidden = true,
          dev = {
            "~/workspace",
            "~/dev",
            "~/projects",
          },
          -- Configured projects from ~/.meowvim.yaml loaded at startup
          -- These projects are shown first by the picker, prioritized over dev directories
          projects = (function()
            local ok, projects_util = pcall(require, "utils.projects")
            if ok then
              return projects_util.get_project_paths()
            end
            return {}
          end)(),
          -- Only scan for git repos in dev dirs, configured projects are always shown first
          patterns = { ".git" },
          -- Include recent projects from vim history
          recent = true,
          confirm = function(picker, item)
            picker:close()
            if not item or not item.file then
              return
            end

            local dir = item.file
            local session_utils = require("utils.session")

            session_utils.save()

            local session_loaded = false
            vim.api.nvim_create_autocmd("SessionLoadPost", {
              once = true,
              callback = function()
                session_loaded = true
              end,
            })

            vim.defer_fn(function()
              if not session_loaded then
                require("snacks").picker.files()
              end
            end, 100)

            session_utils.reset()

            vim.fn.chdir(dir)

            -- Apply project-specific theme from ~/.meowvim.yaml
            local ok, projects_util = pcall(require, "utils.projects")
            if ok then
              projects_util.apply_theme_for_path(dir)
              -- Run project-specific command (e.g., "Roslyn start")
              -- Error handling is done internally by run_command_for_path
              projects_util.run_command_for_path(dir)
            end

            local session = require("snacks").dashboard.sections.session()
            if not session then
              return
            end

            local action = session.action
            if type(action) == "function" then
              action()
              return
            end

            if type(action) == "string" then
              if action:sub(1, 1) == ":" then
                vim.cmd(action:sub(2))
              else
                vim.cmd(action)
              end
            end
          end,
        },
        lsp_workspace_symbols = {
          tree = true,
        },
      },
    },
  },
}
