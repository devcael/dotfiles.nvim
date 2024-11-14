return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
    lazy = false
  },
  {
  "williamboman/mason-lspconfig.nvim",
   dependencies = {
      "mason.nvim",
    },
    lazy = false,
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          'vimls',
          'volar',
          'gopls',
          'volar',
          "lua_ls",
          "html",
          "cssls",
          "clangd"
        },
      }
    end
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })    
    end
  }
}

