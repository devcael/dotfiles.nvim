return {
  { 
    lazy = false,
    priority =  1000,
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        vim.cmd([[colorscheme rose-pine]])
        vim.opt.termguicolors = true
    end
  }
}
