return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	opts = function()
		return require("plugins.gitsigns.config")
	end,
}
