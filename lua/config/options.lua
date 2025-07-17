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

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

opt.backspace = "indent,eol,start"
opt.iskeyword:append("-")
opt.formatoptions:remove({ "c", "r", "o" })
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.sessionoptions = "buffers,tabpages,curdir,folds,winpos,winsize"

opt.title = true
opt.titlestring = "MeowVim - Purr-fect Neovim"

vim.g.disable_autoformat = true
