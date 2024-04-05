vim.g.mapleader = " " -- LeaderKey

-- Mapeamento para Ctrl + e para executar o comando :Ex e abrir o explorador de arquivos
vim.api.nvim_set_keymap('n', '<leader>e', ':Ex<CR>', { noremap = true, silent = true })

-- Mapeamento de Setas pra fazer o resize do split da tela
vim.api.nvim_set_keymap('n', '<M-Up>', [[:resize -5<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-Down>', [[:resize +5<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<M-Left>', [[:vertical resize -5<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-Right>', [[:vertical resize +5<CR>]], { noremap = true, silent = true })

-- Mapeamento de SplitVertical
vim.api.nvim_set_keymap('n', '<leader>/', [[:vsplit<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[:split<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-u><C-t>', [[:UndotreeToggle<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('x', '<leader>p', "\"_dP", { noremap = true, silent = true })