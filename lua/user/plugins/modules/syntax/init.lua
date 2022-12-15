-- -------------------------------- Treesitter ------------------------------- --
use({
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	requires = {
		{
			"p00f/nvim-ts-rainbow",
			event = "BufRead"
		},
		{
			"RRethy/nvim-treesitter-textsubjects",
			event = "BufRead"
		},
		{
			"nvim-treesitter/nvim-treesitter-refactor",
			event = "CursorMoved"
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			event = "CursorMoved"
		},
	},
	config = 'require(P_CONFIGS .. "syntax.treesitter")',
})

use({
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	config = 'require(P_CONFIGS .. "syntax.indentline")',
})

use({
	"andymass/vim-matchup",
	event = "CursorMoved",
	setup = function()
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
		vim.g.matchup_matchparen_deferred = 1
	end,
})

use({
	"kevinhwang91/nvim-ufo",
	event = "BufRead",
	requires = "kevinhwang91/promise-async",
	config = 'require( P_CONFIGS .. "syntax.ufo")',
})
