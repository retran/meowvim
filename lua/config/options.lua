-- SPDX-License-Identifier: MIT
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >

-- @file: lua/config/options.lua
-- @brief: Neovim editor options and settings configuration.

local opt = vim.opt

opt.updatetime = 250
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.synmaxcol = 240

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.laststatus = 3
opt.cmdheight = 1
opt.showmode = false

-- Cursor configuration
opt.guicursor = {
  "n-v-c:block-Cursor/lCursor",
  "i-ci-ve:ver25-Cursor/lCursor",
  "r-cr-o:hor20-Cursor/lCursor",
}

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10
opt.pumblend = 10

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

opt.splitright = true
opt.splitbelow = true

opt.clipboard:append("unnamedplus")

opt.mouse = "a"
opt.mousefocus = true

-- Folding configuration (overridden by nvim-ufo plugin when loaded)
-- Defaults to treesitter-based folding as fallback
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldcolumn = "1"
opt.foldenable = true
opt.foldlevel = 99

opt.backspace = "indent,eol,start"
opt.iskeyword:append("-")
opt.formatoptions:remove({ "c", "r", "o" })
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize,localoptions,resize"

opt.title = true
opt.titlelen = 70

opt.titlestring = "meowvim - Purr-fect Neovim"

opt.spelllang = { "en_us" }
opt.spellsuggest = { "best", "9" }
opt.spelloptions:append("camel")

local spell_dir = vim.fn.stdpath("config") .. "/spell"
vim.fn.mkdir(spell_dir, "p")
opt.spellfile = spell_dir .. "/en.utf-8.add"

local spell_group = vim.api.nvim_create_augroup("meowvim-spell", { clear = true })

-- Ensure cursor is visible if theme doesn't define it
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("meowvim-cursor-fallback", { clear = true }),
  callback = function()
    -- Only set Cursor if theme hasn't defined it
    local cursor_hl = vim.api.nvim_get_hl(0, { name = "Cursor" })
    if not cursor_hl or (not cursor_hl.fg and not cursor_hl.bg and not cursor_hl.reverse) then
      -- Theme didn't set Cursor, use reverse video as fallback
      vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
    end
  end,
})

local function enable_spell(bufnr, opts)
  opts = opts or {}
  vim.api.nvim_buf_call(bufnr, function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = opt.spelllang:get()
    vim.opt_local.spellcapcheck = ""
    if opts.conceal ~= false then
      vim.opt_local.concealcursor = ""
    end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = {
    "gitcommit",
    "markdown",
    "md",
    "mdx",
    "text",
    "norg",
    "rst",
    "tex",
  },
  callback = function(args)
    enable_spell(args.buf)
  end,
})
