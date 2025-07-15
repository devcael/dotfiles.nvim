vim.cmd('syntax enable')

vim.cmd('filetype plugin indent on')

vim.opt.wrap = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.autoindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.mapleader = " "
vim.o.scrolloff = 999 -- Um valor muito alto
vim.opt.fillchars:append({ eob = " " })

vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c:block,i:ver25,r:hor20,o:hor50"

vim.opt.clipboard:append("unnamed")

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
})

function ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match("^user") or name:match("^plugins") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  print("Configuração recarregada!")
end

vim.api.nvim_create_user_command("ReloadConfig", ReloadConfig, {})

require("resources.theme_utils").set_background_transparent()



