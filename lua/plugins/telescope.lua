-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader><C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

function OpenGrepPrompt()
  vim.cmd('command! -nargs=* Grep execute "grep" <q-args>')
  vim.fn.inputsave()
  local cmd = vim.fn.input('Grep > ')
  vim.fn.inputrestore()
  vim.cmd('execute "Grep " . fnameescape(' .. cmd .. ')')
end

vim.api.nvim_set_keymap('n', '<leader>g', ':lua OpenGrepPrompt()<CR>', { noremap = true, silent = true })
