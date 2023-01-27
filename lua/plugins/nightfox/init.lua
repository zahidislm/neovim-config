return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
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
		local scheme = "carbon"

		require("nightfox").setup(opts)
		vim.cmd("colorscheme " .. scheme .. "fox")
	end,
}
