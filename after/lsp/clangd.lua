local lsp_exec = "clangd"

local root_files = {
  ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt",
  "Makefile",
}

local lsp_settings = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true }

return {
  cmd = {
    lsp_exec,
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = root_files,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },
  init_options = lsp_settings,
}
