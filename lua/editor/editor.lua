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
vim.g.mapleader = " "
vim.opt.fillchars:append({ eob = " " })

vim.opt.clipboard:append("unnamed")
