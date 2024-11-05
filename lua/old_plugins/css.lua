local lsp_conf = require("plugins.lsp_config")


require'lspconfig'.cssls.setup{
  on_attach = lsp_conf.on_attach,
  capabilities = lsp_conf.capabilities
}
