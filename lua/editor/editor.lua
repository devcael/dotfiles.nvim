vim.cmd('syntax enable')

vim.cmd('filetype plugin indent on')
vim.opt.wrap = false
vim.o.smartcase = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.autoindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.wo.number = true
vim.wo.relativenumber = true
-- vim.cmd("set termguicolors")
vim.g.mapleader = " "

vim.opt.clipboard:append("unnamed")

-- Appearence
vim.opt.termguicolors = true
vim.cmd [[ colorscheme min-theme ]]

require("resources.theme_utils").set_background_transparent()
