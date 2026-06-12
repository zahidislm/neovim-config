-- PERFORMANCE: Enable Lua bytecode caching and loader optimization
if vim.loader then
  vim.loader.enable()
end

-- Disable built-in plugins
local disabled_built_ins = {
  "gzip", "netrw", "netrwPlugin", "spellfile_plugin", "tar", "tarPlugin", "zip", "zipPlugin",
  "tutor",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.python_host_skip_check = 1

-- Configuration files
require("config.options")
