local M = {
	"neovim/nvim-lspconfig",
	name = "lsp",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"williamboman/mason.nvim",
			cmd = {
				"Mason",
				"MasonInstall",
				"MasonUninstall",
				"MasonLog",
			},
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				config = function()
					require("mason-lspconfig").setup({
						ensure_installed = SERVERS,
						automatic_installation = true,
					})
				end,
			},
			config = function()
				require("mason").setup()
			end,
		},
		{
			"kosayoda/nvim-lightbulb",
			config = function()
				require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
			end,
		},
	},
}

function M.config()
	-- Setup LSP UI
	require("plugins.lang-server.config.diagnostics").setup()

	-- Setup LSP ervers
	local lspconfig = require("lspconfig")
	local lsp_defaults = lspconfig.util.default_config

	-- Code-folding w/ LSP
	lsp_defaults.capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- Combine LSP capabilities w/ cmp_nvim_lsp capabilities
	lsp_defaults.capabilities =
		vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

	require("plugins.lang-server.config.servers").setup()
end

return M
