-- Global LSP Config
vim.lsp.config("*", { root_markers = { ".git" } })

-- Enables LSP Servers defined in root
local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(f, ":t:r")
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

-- LSP Configuration whenever LSP is attaced.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local lsp_keymap = require("config.keymaps.lsp")

    -- Keymaps
    lsp_keymap.global_provider(bufnr)
    lsp_keymap.rename_provider(client, bufnr)
    lsp_keymap.format_provider(client, bufnr)
  end,
})
