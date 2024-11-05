local lsp = require('lspconfig')
local lsp_conf = require('plugins.lsp_config')

lsp.lua_ls.setup {
  on_attach = lsp_conf.on_attach,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      }
    }
  }
}
