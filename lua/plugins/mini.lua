local M = {
	{
		"echasnovski/mini.surround",
		keys = { "ba", "bd", "br", "bf", "bF", "bh", "bn" },
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "ba", -- Add surrounding in Normal and Visual modes
					delete = "bd", -- Delete surrounding
					find = "bf", -- Find surrounding (to the right)
					find_left = "bF", -- Find surrounding (to the left)
					highlight = "bh", -- Highlight surrounding
					update_n_lines = "bn", -- Update `n_lines`
					replace = "br", -- Replace surrounding
				},
			})
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "BufReadPost",
		config = function()
			require("mini.comment").setup()
		end,
	},
}

return M
