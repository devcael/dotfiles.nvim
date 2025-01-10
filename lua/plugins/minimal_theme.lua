return {
  {
    lazy = false,
    priority = 1000,
    'Yazeed1s/minimal.nvim',
    config = function()
      vim.cmd("colorscheme minimal")
      require("resources.theme_utils").set_background_transparent()
    end
  }
}
