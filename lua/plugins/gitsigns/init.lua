return {
	"lewis6991/gitsigns.nvim",
	opts = function()
		return require("plugins.gitsigns.config")
	end,
	event = "BufReadPre",
	module = false,
}
