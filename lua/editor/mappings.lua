vim.g.mapleader = " " -- LeaderKey

-- Mapeamento para selecionar a palavra atual
vim.api.nvim_set_keymap('n', '<leader>w', 'viw', { noremap = true })

-- Mepeamento para copiar texto com Ctrl + Shift + C
vim.api.nvim_set_keymap('n', '<C-S-c>', '"+y', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-S-c>', '"+y', { noremap = true })

-- Mepeamento para colar do clipboard
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true })

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

vim.api.nvim_set_keymap('x', '<leader>p', "\"_dP", { noremap = true, silent = true })

-- Format Buffer Native Lsp
vim.keymap.set('n', '<C-A-L>', vim.lsp.buf.format, { noremap = true, silent = true })

vim.api.nvim_create_user_command(
  "Format",
  function()
    vim.lsp.buf.format()
  end,
  {}
)
