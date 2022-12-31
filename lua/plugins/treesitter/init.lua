local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",

	dependencies = {
		"p00f/nvim-ts-rainbow",
		"RRethy/nvim-treesitter-textsubjects",
		"nvim-treesitter/nvim-treesitter-refactor",
		"nvim-treesitter/nvim-treesitter-context",
	},
}

function M.config()
	local tsConfig = require("plugins.treesitter.config")
	require("nvim-treesitter.configs").setup(tsConfig)
end

return M
