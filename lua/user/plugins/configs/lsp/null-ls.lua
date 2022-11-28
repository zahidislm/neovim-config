local null_present, null_ls = pcall(require, "null-ls")
if not null_present then
    require("packer").compile()
    return
end

local utils = require(P_CONFIGS .. "lsp.lspconfig.utils")

null_ls.setup({
    debounce = 500,
    default_timeout = 10000,
    diagnostics_format = "#{m} (#{s})",
    sources = sources,
    on_attach = utils.on_attach,
})
