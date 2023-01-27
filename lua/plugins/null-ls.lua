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
		ft = LSP_FILETYPES,
		dependencies = { "lsp", "mason" },
		opts = {
			ensure_installed = FORMATTERS,
			automatic_installation = false,
			automatic_setup = true,
		},

		config = function(_, opts)
			require("mason-null-ls").setup(opts)

			require("mason-null-ls").setup_handlers({
				function(source_name, methods)
					require("mason-null-ls.automatic_setup")(source_name, methods)
				end,
			})
		end,
	},
}
