local M = {}

M.settings = {
  Lua = {
    runtime = {
      -- O Neovim usa LuaJIT internamente
      version = "LuaJIT",
    },
    diagnostics = {
      -- Reconhece variáveis globais do ecossistema Neovim/Luajit
      globals = { "vim", "bit", "packer_plugins" },
    },
    workspace = {
      -- Faz o LSP ler os arquivos internos do Neovim para te dar Auto-complete/IntelliSense completo
      library = vim.api.nvim_get_runtime_file("", true),
      -- Evita que o LSP fique perguntando se você quer configurar o ambiente baseado no seu diretório
      checkThirdParty = false,
    },
    telemetry = {
      enable = false,
    },
  },
}

return M
