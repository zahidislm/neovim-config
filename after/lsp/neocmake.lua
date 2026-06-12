local lsp_exec = "neocmakelsp"
local root_files = { "build", "cmake" }

return { cmd = { lsp_exec, "--stdio" }, filetypes = { "cmake" }, root_markers = root_files }
