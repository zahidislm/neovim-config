return {
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = true,
	},

	{
		"zahidislm/chadline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { separator_style = "default" },
	},

	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" } },
			{ "S", mode = { "n", "x", "o" } },
			{ "x", mode = { "x", "o" } },
			{ "X", mode = { "x", "o" } },
		},

		dependencies = {
			"ggandor/leap-spooky.nvim",
			config = true,
		},

		config = function()
			require("leap").add_default_mappings()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		opts = {
			char = "│",
			buftype_exlude = { "terminal", "nofile" },
			filetype_exclude = { "help", "checkhealth", "Mason", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},
}
