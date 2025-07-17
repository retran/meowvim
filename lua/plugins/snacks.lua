local session = require("utils.session")

return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  lazy = false,
  priority = 1000,
  opts = {
    dashboard = {
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Open Project", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[MeowVim v0.1.0]],
      },
      sections = {
        {
          section = "terminal",
          cmd = "cat ~/.config/nvim/assets/icon.ascii",
          height = 17,
          width = 60,
          padding = 1,
          hl = "header"
        },
        { section = "header" },
        { section = "keys",   gap = 0 },
        { section = "startup" },
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
          confirm = function(picker, item)
            local verbose = false

            picker:close()

            session.save(verbose)

            if verbose then
              vim.notify("Resetting Vim state...", vim.log.levels.INFO)
              vim.cmd("%bdelete!")
            else
              vim.cmd("silent! %bdelete!")
            end

            local new_project_dir = item.file
            vim.fn.chdir(new_project_dir)
            if verbose then
              vim.notify("Changed directory to " .. vim.fn.fnamemodify(new_project_dir, ":t"), vim.log.levels.INFO)
            end

            session.load(new_project_dir, verbose)
          end,
        },
      },
    },
  },
}
