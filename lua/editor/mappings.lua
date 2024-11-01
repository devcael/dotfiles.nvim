local keymap = vim.keymap.set
local createCommand = vim.api.nvim_create_user_command
local silent = { silent = true }

-- Mapeamento para selecionar a palavra atual
keymap("n", "<leader>w", "viw", silent)

-- Mepeamento para copiar texto com Ctrl + Shift + C
keymap("n", "<C-S-c>", '"+y', { noremap = true })
keymap("v", "<C-S-c>", '"+y', { noremap = true })

-- Mepeamento para colar do clipboard
keymap("n", "<C-v>", '"+p', { noremap = true })
keymap("i", "<C-v>", "<C-r>+", { noremap = true })

-- Mapeamento para Ctrl + e para executar o comando :Ex e abrir o explorador de arquivos
keymap("n", "<leader>e", ":Ex<CR>", silent)

-- Mapeamento de Setas pra fazer o resize do split da tela
keymap("n", "<M-Up>", [[:resize -5<CR>]], silent)
keymap("n", "<M-Down>", [[:resize +5<CR>]], silent)

keymap("n", "<M-Left>", [[:vertical resize -5<CR>]], silent)
keymap("n", "<M-Right>", [[:vertical resize +5<CR>]], silent)

-- Mapeamento de SplitVertical
keymap("n", "<leader>/", [[:vsplit<CR>]], silent)
keymap("n", "<leader>?", [[:split<CR>]], silent)

keymap("x", "<leader>p", '"_dP', silent)

-- Format Buffer Native Lsp
keymap("n", "<C-A-L>", vim.lsp.buf.format, silent)

keymap(
	"n",
	"<leader>ca",
	vim.lsp.buf.code_action,
  silent
)

createCommand("CodeAction",
function ()
	vim.lsp.buf.code_action()
end, silent)

createCommand("Format",
function()
	vim.lsp.buf.format()
end, silent)

-- Set Background Transparent
createCommand("Transparent", require("resources.theme_utils").set_background_transparent, {})
