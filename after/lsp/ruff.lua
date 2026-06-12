local lsp_exec = "ruff"

local root_files = { "pyproject.toml", "ruff.toml" }

return {
  cmd = { "uvx", lsp_exec, "server" },
  filetypes = { "python" },
  root_markers = root_files,
  init_options = {
    settings = {
      lineLength = 100,
      format = { backend = "uv" },
    },
  },
  on_attach = function (client, _)
    -- Disable everything except formatting & hover
    client.server_capabilities.hoverProvider = false
  end,
}
