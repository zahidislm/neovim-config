local lsp_exec = "ty"

local root_files = { "ty.toml", "pyproject.toml" }

return {
  cmd = { "uvx", lsp_exec, "server" },
  filetypes = { "python" },
  root_markers = root_files,
  settings = {
    ty = {
      showSyntaxErrors = false,
      completions = {
        autoImport = true,
      }
    },
  },
}
