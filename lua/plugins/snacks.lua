-- lua/plugins/snacks.lua

return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  lazy = false,
  priority = 1000,
  opts = {
    dashboard = {
      width = 44,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Open Project", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
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
    image = {},
    scope = {},
    scratch = {
      ft = function()
        return "markdown"
      end,
      filekey = {
        cwd = true,
        branch = false,
        count = true,
      },
    },
    styles = {},

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
            layout = {
              position = "right",
            },
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
        },
      },
    },
  },
}
