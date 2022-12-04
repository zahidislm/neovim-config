-- Asunc autoformatting
local null_utils = require(P_CONFIGS .. "lsp.mason.utils")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Mason / null-ls compat
require("mason-null-ls").setup({
    ensure_installed = FORMATTERS,
    automatic_installation = false,
    automatic_setup = true,
})

require("null-ls").setup({
    debug = false,
    debounce = 500,
    default_timeout = 5000,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    null_utils.async_format(bufnr)
                end,
            })
        end
    end,
})

require 'mason-null-ls'.setup_handlers()
