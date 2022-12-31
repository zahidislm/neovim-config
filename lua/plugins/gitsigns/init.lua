local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
}

function M.config()
	require("plugins.gitsigns.config").setup()
end

return M
