local exec_files = require("resources.exec_files")
exec_files.exec_project_folder("/editor")
require("config.lazy")
exec_files.exec_project_folder("/config/lsp/servers")

