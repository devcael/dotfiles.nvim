local lsp_conf = require("plugins.lsp_config")
local lsp_utils = require("lspconfig/util")


require("lspconfig").gopls.setup({
  on_attach = lsp_conf.on_attach,
  capabilities = lsp_conf.capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lsp_utils.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true
      }
    }
  }
})
