local file_utils = require "utils.file_utils"
local root_dir = vim.fn.stdpath('config') .. "/lua/"
file_utils.load_lua_files(root_dir .. "config")

