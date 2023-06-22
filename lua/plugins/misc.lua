return {
	{
		"ggandor/leap.nvim",
		dependencies = {
			"ggandor/leap-spooky.nvim",
			config = true,
		},
		config = function()
			require("leap").add_default_mappings()
		end,
		keys = {
			{ "s", mode = { "n", "x", "o" } },
			{ "S", mode = { "n", "x", "o" } },
			{ "x", mode = { "x", "o" } },
			{ "X", mode = { "x", "o" } },
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			char = "│",
			buftype_exlude = { "terminal", "nofile" },
			filetype_exclude = { "help", "checkhealth", "mason", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
		event = "BufReadPost",
	},

	{
		"max397574/better-escape.nvim",
		opts = { timeout = 175 },
		event = "InsertEnter",
	},
}
