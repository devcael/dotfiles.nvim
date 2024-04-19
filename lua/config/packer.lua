return require('packer').startup(function(use)
  -- Themes
  use { "rose-pine/neovim", as = "rose-pine" }
  use "rebelot/kanagawa.nvim"
  use 'jdkanani/vim-material-theme'
  use 'foxoman/vim-helix'
  use 'ghifarit53/tokyonight-vim'
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Lsp built in
  use 'neovim/nvim-lspconfig'
  -- Debug
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/cmp-dap'
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
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
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  -- File explorer
  use 'preservim/nerdtree'
  -- Buffers navigation
  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } }
  }
  -- Git
  use 'tpope/vim-fugitive'
  -- Term
  use "akinsho/toggleterm.nvim"

  -- Auto Pairs
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use { 'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  }
end)
