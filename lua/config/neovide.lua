-- MIT License
--
-- Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- @file: lua/config/neovide.lua
-- @brief: Neovide-specific configuration and settings.
-- @author: Andrew Vasilyev
-- @license: MIT
--
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h15"
vim.g.neovide_theme = "dark"

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_position_animation_length = 0.1

vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_cursor_trail_size = 1.0

vim.g.neovide_floating_shadow = false

vim.g.neovide_hide_mouse_when_typing = false

vim.g.neovide_remember_window_size = true

vim.g.neovide_input_macos_option_key_is_meta = "both"

vim.opt.linespace = 3
