return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
    "G",
    "Gdiffsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GDelete",
    "GBrowse",
    "GRemove",
    "GRename",
    "Glgrep",
    "Gedit",
  },
  ft = { "fugitive" },
  dependencies = {
    "tpope/vim-rhubarb",
  },
}
