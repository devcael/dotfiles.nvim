function get_spring_boot_runner(profile, debug)
  local utils = require("resources.utils")
  local env_vars = utils.format_env_vars(utils.load_env_vars(".env")) .. " "

  local debug_param = ""
  if debug then
    debug_param = ' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
  end 

  local profile_param = ""
  if profile then
    profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
  end

  return env_vars .. 'mvn spring-boot:run ' .. profile_param .. debug_param
end

function run_spring_boot(debug)
  vim.cmd('term ' .. get_spring_boot_runner("dev", debug))
end

vim.keymap.set("n", "<F9>", function() run_spring_boot() end)
vim.keymap.set("n", "<C-F12>", function() run_spring_boot(true) end)

