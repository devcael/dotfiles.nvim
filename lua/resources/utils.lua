local ts_utils = require'nvim-treesitter.ts_utils'

local M = {}

function M.os()
  local OSINFO = {}
  local uname = vim.loop.os_uname();
  OSINFO.OS = uname.sysname;
  OSINFO.IS_MAC = OSINFO.OS == 'Darwin'
  OSINFO.IS_LINUX = OSINFO.OS == 'Linux'
  OSINFO.IS_WINDOWS = OSINFO.OS:find 'Windows' and true or false
  OSINFO.IS_WSL = OSINFO.IS_LINUX and uname.release:find 'Microsoft' and true or false
  return OSINFO;
end

function find_node_by_type(expr, type_name)
  while expr do
    if expr:type() == type_name then
        break
    end
    expr = expr:parent()
  end
  return expr
end

function find_child_by_type(expr, type_name)
  local id = 0
  local expr_child = expr:child(id)
  while expr_child do 
    if expr_child:type() == type_name then
      break
    end
    id = id + 1
    expr_child = expr:child(id)
  end

  return expr_child
end

function M.get_current_method_name()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return nil end

  local expr = find_node_by_type(current_node, 'method_declaration')
  if not expr then return nil end

  local child = find_child_by_type(expr, 'identifier')
  if not child then return nil end
  return vim.treesitter.query.get_node_text(child, 0)
end

-- Get Current Class Name
function M.get_current_class_name()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return nil end

  local class_declaration = find_node_by_type(current_node, 'class_declaration')
  if not class_declaration then return nil end
  
  local child = find_child_by_type(class_declaration, 'identifier')
  if not child then return nil end
  return vim.treesitter.query.get_node_text(child, 0)
end

function M.get_current_package_name()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return nil end

  local program_expr = find_node_by_type(current_node, 'program')
  if not program_expr then return nil end
  local package_expr = find_child_by_type(program_expr, 'package_declaration')
  if not package_expr then return nil end

  local child = find_child_by_type(package_expr, 'scoped_identifier')
  if not child then return nil end
  return vim.treesitter.query.get_node_text(child, 0)
end

function M.get_current_full_class_name()
  local package = M.get_current_package_name()
  local class = M.get_current_class_name()
  return package .. '.' .. class
end

function M.get_current_full_method_name(delimiter)
  delimiter = delimiter or '.'
  local full_class_name = M.get_current_full_class_name()
  local method_name = M.get_current_method_name()
  return full_class_name .. delimiter .. method_name
end

return M
