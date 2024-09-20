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
    'volar',
    'gopls',
    'volar',
    "lua_ls",
    "rust_analyzer",
    "html",
    "cssls"
  },
}

-- Needs java-debug-adapter, java-test, prettier
