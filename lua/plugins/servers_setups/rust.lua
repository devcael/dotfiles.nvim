local lsp_conf = require("plugins.lsp_config")
local lsp_util = require("lspconfig/util")

local opts = {
  tools = {  -- rust-tools options
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    on_attach = lsp_conf.on_attach,
    capabilities = lsp_conf.capabilities,
    ["rust-analyzer"] = {
      -- enable clippy on save
      checkOnSave = {
        command = "clippy"
      },
    }
  }
}

require('rust-tools').setup(opts);
