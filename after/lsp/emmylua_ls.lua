local lsp_exec = "emmylua_ls"

local root_files = {
  ".luarc.json", ".emmyrc.json", ".luacheckrc", ".luafmt.toml", "luafmt.toml", "init.lua",
}

local lsp_settings = { Lua = { diagnostics = { globals = { "vim" } } } }

return {
  cmd = { lsp_exec },
  filetypes = { "lua" },
  root_markers = root_files,
  settings = lsp_settings,
  workspace_required = false,
}
