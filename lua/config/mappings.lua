local keymap = vim.keymap.set
local createCommand = vim.api.nvim_create_user_command
local silent = { silent = true }
local mn = require("resources.keymap_utils").mapNum

keymap("n", "<leader>w", ":w<CR>", silent)
keymap("n", "fj", "<C-d>", silent)
keymap("n", "fk", "<C-u>", silent)

keymap("i", "jj", "<Esc>", { noremap = true })

keymap("n", "<C-s>", ":w<CR>", { noremap = true })
-- keymap("n", "<C-q>", ":wqa<CR>", { noremap = true })
keymap("n", "<C-x>", ":q!<CR>", { noremap = true })
keymap("n", "<leader>x", ":q!<CR>", { noremap = true })


-- Mepeamento para copiar texto com Ctrl + Shift + C
keymap("n", "<C-S-c>", '"+y', { noremap = true })
keymap("v", "<C-S-c>", '"+y', { noremap = true })

-- Mepeamento para colar do clipboard
keymap("n", "<C-v>", '"+p', { noremap = true })
keymap("i", "<C-v>", "<C-r>+", { noremap = true })

-- Mapeamento para Ctrl + e para executar o comando :Ex e abrir o explorador de arquivos
-- keymap("n", "<leader>e", ":Ex<CR>", silent)

-- Mapeamento de Setas pra ler o resize do split da tela
keymap("n", "<M-Up>", [[:resize -5<CR>]], silent)
keymap("n", "<M-Down>", [[:resize +5<CR>]], silent)

keymap("n", "<M-Left>", [[:vertical resize -5<CR>]], silent)
keymap("n", "<M-Right>", [[:vertical resize +5<CR>]], silent)

-- Mapeamento de SplitVertical
keymap("n", "<leader>/", [[:vsplit<CR>]], { silent = true, noremap = true })
keymap("n", "<leader>?", [[:split<CR>]], silent)

keymap("x", "<leader>p", '"_dP', silent)

-- Format Buffer Native Lsp
keymap("n", "<C-A-L>", vim.lsp.buf.format, silent)

keymap(
  "n",
  "<leader>ca",
  vim.lsp.buf.code_action,
  {}
)

createCommand("CodeAction",
  function()
    vim.lsp.buf.code_action()
  end, {})

createCommand("Format",
  function()
    vim.lsp.buf.format()
  end, {})

-- Set Background Transparent
createCommand("Transparent", require("resources.theme_utils").set_background_transparent, {})


function OpenGrepPrompt()
  vim.cmd('command! -nargs=* Grep execute "grep" <q-args>')
  vim.fn.inputsave()
  local cmd = vim.fn.input('Grep > ')
  vim.fn.inputrestore()
  vim.cmd('execute "Grep " . fnameescape(' .. cmd .. ')')
end

vim.api.nvim_set_keymap('n', '<leader>g', ':lua OpenGrepPrompt()<CR>', { noremap = true, silent = true })


function hide_diagnostics()
  vim.diagnostic.config({
    virtual_text = false,
    underline = false,
  })
end

function show_diagnostics()
  vim.diagnostic.config({
    virtual_text = true,
    underline = true,
  })
end

-- Desabilitar e habilitar os diagnostics
vim.keymap.set("n", "<leader>dh", hide_diagnostics)
vim.keymap.set("n", "<leader>ds", show_diagnostics)

-- Salvar arquivo com Ctrl + S
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- No modo inserção, sair para o modo normal e salvar o arquivo
-- vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- No modo inserção, sair para o modo normal e salvar o arquivo
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- Fechar arquivo com Espace + Qvim
vim.keymap.set("n", "<leader>q", ":bd<CR>", { noremap = true, silent = true })

-- Salvar arquivo com F12 no modo Normal
vim.api.nvim_set_keymap('n', '<F12>', ':w<CR>', { noremap = true, silent = true })

-- Salvar arquivo com F12 no modo Inserção
vim.api.nvim_set_keymap('i', '<F12>', '<Esc>:w<CR>', { noremap = true, silent = true })

-- Remapear 'dl' para deletar a linha inteira
vim.api.nvim_set_keymap('n', 'dl', 'dd', { noremap = true, silent = true })

-- Mover linha para baixo
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
-- Mover linha para cima
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Substituir palavra abaixo do cursor
vim.api.nvim_set_keymap('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>', { noremap = true, silent = false })
--
vim.api.nvim_set_keymap('n', 'xi', 'ci\'', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'xI', 'ci"', { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', 'xai', 'ca\'', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'xaI', 'ca"', { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', 'xo', 'di\'', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'xO', 'di"', { noremap = true, silent = false })

vim.api.nvim_set_keymap('n', 'xao', 'da\'', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', 'xaO', 'da"', { noremap = true, silent = false })

-- Mover para a janela à esquerda, direita, acima ou abaixo
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })

-- Mover para a janela à esquerda
vim.api.nvim_set_keymap('n', '<Left>', '<C-w>h', { noremap = true, silent = true })

-- Mover para a janela à direita
vim.api.nvim_set_keymap('n', '<Right>', '<C-w>l', { noremap = true, silent = true })

-- Mover para a janela acima
vim.api.nvim_set_keymap('n', '<Up>', '<C-w>k', { noremap = true, silent = true })

-- Mover para a janela abaixo
vim.api.nvim_set_keymap('n', '<Down>', '<C-w>j', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'cw', 'caw', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'dw', 'daw', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'cW', 'caW', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'dW', 'daW', { noremap = true, silent = true })

-- Desabilitar copilor leader + dc
vim.api.nvim_set_keymap('n', '<leader>dc', ':Copilot disable<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ec', ':Copilot enable<CR>', { noremap = true, silent = true })

-- Go-specific mappings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    local opts = { buffer = true, silent = true }
    
    -- Go build and run
    keymap("n", "<leader>gb", ":GoBuild<CR>", opts)
    keymap("n", "<leader>gr", ":GoRunProject<CR>", opts) -- Usar comando personalizado
    keymap("n", "<leader>gt", ":GoTest<CR>", opts)
    keymap("n", "<leader>gtf", ":GoTestFunc<CR>", opts)
    keymap("n", "<leader>gtp", ":GoTestPkg<CR>", opts)
    
    -- Go formatting and imports
    keymap("n", "<leader>gf", ":GoFmt<CR>", opts)
    keymap("n", "<leader>gi", ":GoImport<CR>", opts)
    keymap("n", "<leader>gim", ":GoImports<CR>", opts)
    
    -- Go debugging
    keymap("n", "<leader>gdt", ":GoDebugTest<CR>", opts)
    keymap("n", "<leader>gdb", ":GoDebugBreakpoint<CR>", opts)
    
    -- Go coverage
    keymap("n", "<leader>gcov", ":GoCoverage<CR>", opts)
    keymap("n", "<leader>gcot", ":GoCoverageToggle<CR>", opts)
    
    -- Go tools
    keymap("n", "<leader>gta", ":GoAddTag<CR>", opts)
    keymap("n", "<leader>gtr", ":GoRmTag<CR>", opts)
    keymap("n", "<leader>gif", ":GoIfErr<CR>", opts)
    
    -- Go project configuration
    keymap("n", "<leader>gcc", ":GoCreateConfig<CR>", opts)
    keymap("n", "<leader>gcl", ":GoListConfigs<CR>", opts)
    keymap("n", "<leader>grp", ":GoRunProject<CR>", opts)
  end,
})
