-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/plugins/snacks.lua
-- @brief: Collection of useful utilities and UI components.

-- luacheck: globals Snacks

return {
  "folke/snacks.nvim",
  version = "v2.*", -- Pin to stable 2.x releases
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>hn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename()
      end,
      desc = "Rename File",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal (which-key)",
    },
    {
      "]w",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
    },
    {
      "[w",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    local patches = require("utils.patches")
    if type(patches.patch_snacks_picker) == "function" then
      patches.patch_snacks_picker()
    end
  end,
  opts = function()
    local config_ok, config = pcall(require, "meowvim.config")
    local image_preview = true
    local scope_highlighting = true
    local custom_styles = true

    if config_ok then
      image_preview = config.get("snacks.image_preview", true)
      scope_highlighting = config.get("snacks.scope_highlighting", true)
      custom_styles = config.get("snacks.custom_styles", true)
    end

    return {
      dashboard = {
        width = 52,
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
          { section = "header", padding = 1 },
          { section = "projects", padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
          { section = "startup", padding = 1 },
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
      image = {
        enabled = false, -- broken with nvim 0.12.x: treesitter `range` API removed
      },
      scope = {
        enabled = scope_highlighting,
        treesitter = {
          enabled = true,
        },
      },
      scratch = {
        ft = "markdown",
        filekey = {
          cwd = true,
          branch = false,
          count = true,
        },
      },
      styles = {
        enabled = custom_styles,
        notification = {
          wo = {
            winblend = 0,
            wrap = false,
          },
        },
      },

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
            -- Configured projects from ~/.config/meowvim/projects.lua
            projects = (function()
              local ok, cfg = pcall(require, "meowvim.config")
              if ok then
                return cfg.get_project_paths()
              end
              return {}
            end)(),
            -- Only scan for git repos in dev dirs, configured projects are always shown first
            patterns = { ".git" },
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

              local ok, cfg = pcall(require, "meowvim.config")
              if ok then
                local current_project = cfg.detect_current_project()
                if current_project and current_project.on_open then
                  vim.defer_fn(function()
                    vim.cmd(current_project.on_open)
                  end, 150)
                end
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
    }
  end,
}
