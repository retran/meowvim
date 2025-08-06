return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local function is_headless()
      if vim.v.argv == nil then
        return false
      end
      for _, arg in ipairs(vim.v.argv) do
        if arg == "--headless" then
          return true
        end
      end
      return false
    end

    require("tokyonight").setup({
      transparent = not vim.g.neovide and not is_headless(),
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    })
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
