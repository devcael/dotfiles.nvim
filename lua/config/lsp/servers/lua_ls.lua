local lsp = require('lspconfig')
local lsp_conf = require('config.lsp.commom')

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
