local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

-- LSP UI config
require(P_CONFIGS .. "lsp.lspconfig.ui")

-- Code-folding w/ LSP
lsp_defaults.capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- Combine LSP capabilities w/ cmp_nvim_lsp capabilities
lsp_defaults.capabilities =
	vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- LSP Server registration
require(P_CONFIGS .. "lsp.lspconfig.servers")
