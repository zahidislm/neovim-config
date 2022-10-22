local null_present, null_ls = pcall(require, "null-ls")
if not null_present then
    require("packer").compile()
    return
end

local utils = require("user.plugins.config.lspconfig.utils")
-- local null_ls_sources = require("user.plugins.config.null_ls.sources")

local sources = {
    -- Formatters
    null_ls.builtins.formatting.yapf,
    null_ls.builtins.formatting.rustfmt,
    -- Diagnostics
}

null_ls.setup({
    debounce = 500,
    default_timeout = 10000,
    diagnostics_format = "#{m} (#{s})",
    sources = sources,
    on_attach = utils.on_attach,
})
