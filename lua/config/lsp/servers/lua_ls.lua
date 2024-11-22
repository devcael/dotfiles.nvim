local M = {}

M.settings = {
  Lua = {
    runtime = {
      version = "LuaJIT"
    },
    diagnostics = {
      globals = { 'vim', 'bit', 'packer_plugins' }
    }
  }
}

return M

