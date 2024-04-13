require("config.packer")
local exec_files = require("resources.exec_files")
exec_files.exec_project_folder("/editor")
exec_files.exec_project_folder("/plugins")

