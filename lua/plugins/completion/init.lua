return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- snippet engine
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy",

			-- sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			"FelipeLema/cmp-async-path",

			-- misc
			"onsails/lspkind.nvim",
		},
		opts = function()
			return require("plugins.completion.config")
		end,
		version = false,
	},
}
