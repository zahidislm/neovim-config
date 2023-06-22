return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = {
			debounce = 250,
			save_after_format = false,
		},
	},

	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = { "lsp", "mason" },
		opts = {
			ensure_installed = FORMATTERS,
			automatic_installation = false,
			handlers = {},
		},
		event = "BufReadPost",
	},
}
