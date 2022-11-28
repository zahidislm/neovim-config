-- Default diagnostic settings
vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- Set completion icons
vim.fn.sign_define("DiagnosticsSignError", { text = ICON_ERROR })
vim.fn.sign_define("DiagnosticsSignWarning", { text = ICON_WARN })
vim.fn.sign_define("DiagnosticsSignInformation", { text = ICON_INFO })
vim.fn.sign_define("DiagnosticsSignHint", { text = ICON_HINT })

-- Set square borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

local lspconfig = require('lspconfig')
local utils = require(P_CONFIGS .. "lsp.lspconfig.utils")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

require('lspconfig')['pyright'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}

require('lspconfig')['rust_analyzer'].setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
