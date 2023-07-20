return {
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			char = "│",
			filetype_exclude = { "lspinfo", "checkhealth", "help", "fzf", "lazy", "man", "mason", "" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
			show_foldtext = false,
			use_treesitter = true,
		},
		event = "VeryLazy",
	},

	{
		"max397574/better-escape.nvim",
		opts = { timeout = 175 },
		event = "InsertEnter",
	},
}
