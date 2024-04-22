vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')
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
vim.cmd("set termguicolors")
vim.g.mapleader = " "

vim.opt.clipboard:append("unnamed")

-- Appearence
vim.cmd.colorscheme("catppuccin")
