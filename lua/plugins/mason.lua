require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup {
  ensure_installed = {
    'vimls',
    'gopls',
    'volar',
    'tsserver',
    "lua_ls",
    "rust_analyzer"
  },
}
