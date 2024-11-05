local lsp_config = require 'plugins.lsp_config'

require'lspconfig'.html.setup({
  on_attach = lsp_config.on_attach,
  capabilities = lsp_config.capabilities,
  root_dir = vim.loop.cwd,
})

