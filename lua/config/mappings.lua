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


-- Lsp
local lsp_zero = require('lsp-zero')

local lsp_format_on_save = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

lsp_zero.on_attach(function(client, bufnr)
  lsp_format_on_save(bufnr);
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)
