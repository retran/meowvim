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
        header = [[Meowvim
-------]],
      },
      sections = {
        {
          pane = 1,
          height = 17,
          padding = 1,
          section = "terminal",
          cmd = "~/.config/nvim/scripts/icon.sh",
        },
        {
          pane = 2,
          {
            section = "header",
            padding = 1
          },
          {
            section = "projects",
            padding = 1,
            action = function(dir)
              vim.fn.chdir(dir)
            end,
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
    notifier = {},
    input = {},
    terminal = {},
    bigfile = {},
    dim = {},
    explorer = {},
    image = {},
    scope = {},
    styles = {},
    toggle = {},
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
          hidden = true,
        },
        projects = {
          hidden = true,
        },
      },
    },
  },
}
