return {
	"lewis6991/gitsigns.nvim",
	name = "GitSigns",
	opts = function()
		return require("plugins.gitsigns.config")
	end,
	event = "BufReadPre",
}
