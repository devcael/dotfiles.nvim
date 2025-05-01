local command = require("config.utils.command_utils")

local M = {}

local get_ts_lib_path = function()
  local node_modules = command.run("npm root -g")
  local vue_lib =  "/@vue/typescript-plugin";
  local lib_path = node_modules .. vue_lib

  if command.path_exists(lib_path) then
    return lib_path
  end
end

local get_vue_lib_path = function()
  local node_modules = command.run("npm root -g")
  local ts_lib =  "/typescript/lib";
  local lib_path = node_modules .. ts_lib

  if command.path_exists(lib_path) then
    return lib_path
  end
end


local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = 'rounded',
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  ),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
}

local settings = {
  typescript = {
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValues = { enabled = true },
    },
    suggest = {
      includeCompletionsForModuleExports = false,
    },
  },
  javascript = {
    inlayHints = {
      parameterNames = { enabled = "literals" },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValues = { enabled = true },
    },
    suggest = {
      includeCompletionsForModuleExports = false,
    },
  },
}


local on_attach = function(_, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
end

M.handlers = handlers
M.settings = settings
M.on_attach = on_attach
M.get_tsdk = get_ts_lib_path
M.get_vue_lib_path = get_vue_lib_path

return M

