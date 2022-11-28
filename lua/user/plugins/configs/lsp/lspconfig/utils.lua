local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Use the following when ls attches to a buffer
M.on_attach = function(client, bufnr)
    b_opts = { buffer = bufnr, silent = true }

    -- Mappings
    require(P_MAPPINGS .. "lsp.lspconfig")

    -- Format on save if formatting is available
    if client.server_capabilities.documentFormattingProvider
        or client.server_capabilities.documentRangeFormattingProvider
    then
        local group = vim.api.nvim_create_augroup("lsp_format_onsave", { clear = false })
        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ timeout_ms = 2000 })
            end,
            desc = "Format using lsp/null-ls on save.",
            group = group,
        })
    end
end

return M
