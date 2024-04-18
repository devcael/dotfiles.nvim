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

return M
