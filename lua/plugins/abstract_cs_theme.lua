return {
  {
    lazy = false,
    priority = 1000,
    'Abstract-IDE/Abstract-cs',
    config = function()
      vim.cmd("colorscheme abscs")
      -- require("resources.theme_utils").set_background_transparent()
    end
  }
}
