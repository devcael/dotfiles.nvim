
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "markdown", "json", "query", "go", "dart", "java", "rust" },
  sync_install = false,
  auto_install = true,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    disable = { },
  },
}

require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
