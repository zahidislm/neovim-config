-- Setup LSP Servers installed w/ Mason
require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({})
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
		})
	end,
})
