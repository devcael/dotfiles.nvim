local lsp_cong = require("plugins.lsp_config");

require("lspconfig").jsonls.setup({
  on_attach = lsp_cong.on_attach,
  capabilities = lsp_cong.capabilities
})
