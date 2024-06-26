local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local buffer_searcher
buffer_searcher = function()
    builtin.buffers {
        sort_mru = true,
        ignore_current_buffer = true,
        show_all_buffers = false,
        attach_mappings = function(prompt_bufnr, map)
        local refresh_buffer_searcher = function()
            actions.close(prompt_bufnr)
            vim.schedule(buffer_searcher)
        end
        local delete_buf = function()
            local selection = action_state.get_selected_entry()
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
            refresh_buffer_searcher()
        end
        local delete_multiple_buf = function()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selection = picker:get_multi_selection()
            for _, entry in ipairs(selection) do
                vim.api.nvim_buf_delete(entry.bufnr, { force = true })
        end
        refresh_buffer_searcher()
    end
    map('n', 'dd', delete_buf)
    map('n', '<C-d>', delete_multiple_buf)
    map('i', '<C-d>', delete_multiple_buf)
    return true
end
}
end

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader><C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-b>', buffer_searcher, {})
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
