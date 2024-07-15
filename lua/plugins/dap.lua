
local key_map = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

-- Setup debug
key_map('n', '<F8>', ':lua require"dap".toggle_breakpoint()<CR>')
key_map('n', '<leader>bc', ':lua require"dap".set_breakpoint(vim.fn.input("Condition: "))<CR>')
key_map('n', '<leader>bl', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log: "))<CR>')
key_map('n', '<leader>dr', ':lua require"dap".repl.open()<CR>')


-- Dap Ui
function show_dap_centered_scopes()
  local widgets = require'dap.ui.widgets'
  widgets.centered_float(widgets.scopes)
end
key_map('n', 'cs', ':lua show_dap_centered_scopes()<CR>')

-- Move in debug
key_map('n', '<F9>', ':lua require"dap".continue()<CR>')
key_map('n', '<F6>', ':lua require"dap".step_over()<CR>')
key_map('n', '<F7>', ':lua require"dap".step_into()<CR>')
key_map('n', '<S-F8>', ':lua require"dap".step_out()<CR>')


-- Java
local dap = require('dap')

dap.configurations.java = {
  {
    type = 'java';
    request = 'attach';
    name = "Debug (Attach) - Remote";
    hostName = "127.0.0.1";
    port = 5005;
  },
}

function attach_to_debug()
  local dap = require('dap')
  dap.continue()
end 

key_map('n', '<leader>da', ':lua attach_to_debug()<CR>')


