local command = require("config.utils.command_utils")

local M = {}

local get_vue_plugin_path = function()
  local node_modules = command.run("npm root -g")
  local lib_path = node_modules .. "/@vue/typescript-plugin"
  if command.path_exists(lib_path) then
    return lib_path
  end
end

local get_tsdk_path = function()
  local node_modules = command.run("npm root -g")
  local lib_path = node_modules .. "/typescript/lib"
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
M.get_tsdk = get_tsdk_path
M.get_vue_plugin_path = get_vue_plugin_path

return M

