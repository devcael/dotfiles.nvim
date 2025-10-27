local M = {}

M.set_background_transparent = function()
  vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi SignColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi VertSplit guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi FoldColumn guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi LineNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi CursorLineNr guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi NonText guibg=NONE ctermbg=NONE]])
  vim.cmd([[hi NormalFloat guibg=NONE ctermbg=NONE]])
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "MyPMenu", { bg = "none", fg = "White" })
  vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "none", fg = "White", bold = true })
end

M.set_background_normal = function()
  vim.cmd([[hi Normal guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi NormalNC guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi SignColumn guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi VertSplit guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi FoldColumn guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi LineNr guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi CursorLineNr guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi NonText guibg=#282c34 ctermbg=235]])
  vim.cmd([[hi NormalFloat guibg=#282c34 ctermbg=235]])
  vim.api.nvim_set_hl(0, "Normal", { bg = "#282c34" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282c34" })
  vim.api.nvim_set_hl(0, "MyPMenu", { bg = "#282c34", fg = "White" })
  vim.api.nvim_set_hl(0, "MyPmenuSel", { bg = "#61afef", fg = "Black", bold = true })
end

return M
