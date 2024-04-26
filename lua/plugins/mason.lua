require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})


require('mason-tool-installer').setup {
  ensure_installed = {
    { 'bash-language-server', auto_update = true },
    'lua-language-server',
    'vim-language-server',
    'gopls',
    'rust-analyzer',
    'typescript-language-server',
    'vue-language-server',
    'css-lsp',
    'html-lsp',
    'tailwindcss-language-server',
    'java-test',
    "java-debug-adapter",
    "java-language-server",
    "jdtls"
  },
  run_on_start = true,
  start_delay = 1000, -- 3 second delay
  debounce_hours = 1, -- at least 5 hours between attempts to install/update
}
