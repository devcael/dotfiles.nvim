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

vim.api.nvim_set_keymap('n', '<C-u><C-t>', [[:UndotreeToggle<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('x', '<leader>p', "\"_dP", { noremap = true, silent = true })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<C-g>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Nerdtree
vim.keymap.set('n', '<C-e>', "<cmd>:NERDTreeToggle<cr>", { silent = true });
vim.keymap.set('n', '<leader>nf', "<cmd>:NERDTreeFind<cr>", { silent = true });
vim.keymap.set('n', '<leader>e', "<cmd>:NERDTreeFocus<cr>", { silent = true });


-- Lsp


-- Harpoon
local h_mark = require("harpoon.mark")
local h_ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", h_mark.add_file)
vim.keymap.set("n", "<leader>hh", h_ui.toggle_quick_menu)

vim.keymap.set("n", "<C-b>", h_ui.nav_next, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>1", function()
  h_ui.nav_file(1)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>2", function()
  h_ui.nav_file(2)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>3", function()
  h_ui.nav_file(3)
end, { noremap = true, silent = true })
