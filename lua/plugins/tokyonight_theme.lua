return {
  {
    lazy = false,
    priority = 1000,
    "tiagovla/tokyodark.nvim",
    name = "tokyodark",
    opts = {
      transparent_background = true,
      comments = { italic = false },
      keywords = { italic = false },
      identifiers = { italic = false },
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd("colorscheme tokyodark")
      require("resources.theme_utils").set_background_transparent()
    end,
  }
}
