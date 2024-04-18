return require('packer').startup(function(use)
  -- Themes
  use "rebelot/kanagawa.nvim"
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Lsp built in
  use 'neovim/nvim-lspconfig'
  -- Cmp - Code Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- Snippets for 
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- Common configurations
  use "nvim-lua/plenary.nvim"
  -- Lsp instalation
  use {
    "williamboman/mason.nvim"
  }
  use {
    "williamboman/mason-lspconfig.nvim"
  }
  -- Search Files
  use {
    "nvim-telescope/telescope.nvim",
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- File explorer
  use 'preservim/nerdtree'
  -- Buffers navigation
  use 'ThePrimeagen/harpoon'
  -- Git
  use 'tpope/vim-fugitive'
  -- Term
  use "akinsho/toggleterm.nvim"
end)
