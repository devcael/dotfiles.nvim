return {
  {
    "tiagovla/tokyodark.nvim",
    name = "tokyodark",
    opts = {
      transparent_background = true,
      comments = { italic = false },
      keywords = { italic = false },
      identifiers = { italic = false },
      functions = { italic = false },
      variables = { italic = false },
      strings = { italic = false },
      operators = { italic = false },
      numbers = { italic = false },
      boolean = { italic = false },
      constants = { italic = false },
      methods = { italic = false },
      fields = { italic = false },
      attributes = { italic = false },
      classes = { italic = false },
      modules = { italic = false },
      properties = { italic = false },
      events = { italic = false },
      conditions = { italic = false },
      exceptions = { italic = false },
      parameters = { italic = false },
      types = { italic = false },
    },
    config = function(_, opts)
      -- require("tokyodark").setup(opts)
      -- vim.cmd("colorscheme tokyodark")
      -- require("resources.theme_utils").set_background_transparent()
    end,
  }
}
