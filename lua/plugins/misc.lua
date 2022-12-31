local M = {
	"folke/which-key.nvim",
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"EtiamNullam/deferred-clipboard.nvim",
		event = "VeryLazy",
		config = function()
			require("deferred-clipboard").setup()
		end,
	},
	{
		"zahidislm/statusline.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("statusline_nvim").setup()
		end,
	},
	{
		"ggandor/leap.nvim",
		keys = { "s", "S" },
		dependencies = {
			"ggandor/leap-spooky.nvim",
			config = function()
				require("leap-spooky").setup()
			end,
		},
		config = function()
			require("leap").add_default_mappings()
		end,
	},
}

return M
