return {
	{
		"zahidislm/chadline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			overriden_modules = {
				fileInfo = function()
					return ""
				end,
			},
		},
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
			filetype_exclude = { "help", "checkhealth", "mason", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},
}
