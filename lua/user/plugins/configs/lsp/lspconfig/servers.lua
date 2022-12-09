-- MAPPINGS
local lsp_mappings = require(P_MAPPINGS .. "lsp")
local on_attach = function(client, bufnr)
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	lsp_mappings.init(bufopts)
end

-- Setup LSP Servers installed w/ Mason
require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
		})
	end,

	["sumneko_lua"] = function()
		require("lspconfig")["sumneko_lua"].setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = {
							"vim",
							"PARSERS",
							"SERVERS",
							"FORMATTERS",
							"P_CONFIGS",
							"P_MAPPINGS",
							"P_MODULES",
						},
					},
				},
			},

			on_attach = on_attach,
		})
	end,
})
