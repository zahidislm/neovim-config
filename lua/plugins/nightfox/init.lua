return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	name = "default-colorscheme",
	opts = {
		options = {
			dim_inactive = true,
			module_default = false,
			inverse = { match_paren = true },

			modules = {
				cmp = true,
				diagnostic = { enable = true, background = true },
				gitsigns = true,
				mini = true,
				native_lsp = { enable = true, background = true },
				treesitter = true,
				whichkey = true,
			},
		},

		groups = { all = require("plugins.nightfox.spec").highlights },
	},

	config = function(_, opts)
		require("nightfox").setup(opts)
	end,
}
