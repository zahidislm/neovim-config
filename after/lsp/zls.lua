local lsp_exec = "zls"
local root_files = { "zls.json", "build.zig" }

return {
  cmd = { lsp_exec },
  filetypes = { "zig" },
  root_markers = root_files,
  workspace_required = false,
  settings = {
    zls = {
      enable_build_on_save = true,
      build_on_save_step = "check",
    },
  },
}
