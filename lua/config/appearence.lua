vim.cmd.colorscheme("catppuccin")

function background_transparent()
  vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
  -- SignComumn é a coluna onde ficam os números de linhas
  vim.cmd([[hi SignColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi VertSplit guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi FoldColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi LineNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi CursorLineNr guibg=NONE ctermbg=NONE]])

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "MyPMenu", { bg = "none", fg = "White" })
  vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "none", fg = "White", bold = true })
end

function background_setcolor()
  vim.cmd([[hi SignColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi VertSplit guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi FoldColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi LineNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi CursorLineNr guibg=NONE ctermbg=NONE]])
  vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = color, fg = "White", bold = true })
end

background_setcolor()
