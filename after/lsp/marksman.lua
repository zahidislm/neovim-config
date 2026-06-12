local lsp_exec = "marksman"

local root_files = { ".marksman.toml" }

return { cmd = { lsp_exec, "server" }, filetypes = { "markdown" }, root_markers = root_files }
