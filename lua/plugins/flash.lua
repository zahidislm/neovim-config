return {
	"folke/flash.nvim",
	opts = {
		label = { uppercase = false },
		prompt = { enabled = false },
		modes = {
			char = {
				autohide = true,
				multi_line = false,
			},
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash search",
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Remote flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash treesitter search",
		},
		{ "f", mode = { "n", "x", "o" } },
		{ "F", mode = { "n", "x", "o" } },
		{ "t", mode = { "n", "x", "o" } },
		{ "T", mode = { "n", "x", "o" } },
		{ "/", mode = { "n" } },
		{ "?", mode = { "n" } },
	},
}
