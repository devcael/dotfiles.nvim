local command = require("config.utils.command_utils")

local M = {}

local get_ts_lib_path = function()
  local node_modules = command.run("npm root -g")
  local vue_lib =  "/@vue/typescript-plugin";
  local lib_path = node_modules .. vue_lib

  if command.path_exists(lib_path) then
    return lib_path
  end

  print("installing  vue/typescript plugin")
  local result = command.run("npm install -g @vue/typescript-plugin")
  print(result)
end

local get_vue_lib_path = function()
  local node_modules = command.run("npm root -g")
  local ts_lib =  "/typescript/lib";
  local lib_path = node_modules .. ts_lib

  if command.path_exists(lib_path) then
    return lib_path
  end

  print("installing typescript plugin")
  local result = command.run("npm install -g typescript")
  print(result)
end


local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    silent = true,
    border = true,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = true }
  ),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = true }
  ),
  -- ["textDocument/definition"] = function(err, result, method, ...)
  --   if vim.tbl_islist(result) and #result > 1 then
  --     local filtered_result = filter(result, filterReactDTS)
  --     return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
  --   end

  --   vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
  -- end,
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


local on_attach = function(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr })
  -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

M.handlers = handlers
M.settings = settings
M.on_attach = on_attach
M.get_tsdk = get_ts_lib_path
M.get_vue_lib_path = get_vue_lib_path

return M

