return require('packer').startup(function(use)
  -- Airline
  use {
    'nvim-lualine/lualine.nvim'
  }

  use 'wakatime/vim-wakatime'

  -- Themes
  use "nvim-tree/nvim-web-devicons"
  use 'datsfilipe/min-theme.nvim'
  use 'AlexvZyl/nordic.nvim'
  use "nyoom-engineering/oxocarbon.nvim"
  use 'wojciechkepka/vim-github-dark'
  use 'xStormyy/bearded-theme.nvim'
  use { "rose-pine/neovim", as = "rose-pine" }
  use "rebelot/kanagawa.nvim"
  use 'jdkanani/vim-material-theme'
  use 'foxoman/vim-helix'
  use 'ghifarit53/tokyonight-vim'
  use { "catppuccin/nvim", as = "catppuccin" }
  -- Java Setup
  use 'mfussenegger/nvim-jdtls'
  -- Ts Formatter
  use('MunifTanjim/prettier.nvim')
  -- Rust Format
  use 'rust-lang/rust.vim'
  -- Todo: Maybe Add Rustacean https://github.com/mrcjkb/rustaceanvim/tree/master?tab=readme-ov-file#books-usage--features

  use 'simrat39/rust-tools.nvim'

  use 'redhat-developer/vscode-java'

  -- Golang dap
  use "leoluz/nvim-dap-go"

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Lsp built in
  use 'neovim/nvim-lspconfig'
  -- Debug
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/cmp-dap'
  use 'nvim-neotest/nvim-nio'
  use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }
  -- Cmp - Code Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- Snippets for
  use('jose-elias-alvarez/null-ls.nvim')
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
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  }
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
